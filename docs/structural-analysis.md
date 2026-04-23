# Mineral Core — Analyse Structurelle & Réduction de Charge Cognitive

> Généré le 2026-04-23. Basé sur l'audit de la codebase v4.2.0 (492 fichiers Dart, ~10k LoC).

---

## Vue d'ensemble

| Couche | Chemin | Fichiers | Rôle |
|--------|--------|----------|------|
| API | `src/api/` | ~166 | Modèles publics, DTOs, builders |
| Domains | `src/domains/` | ~70 | Contrats métier, logique applicative |
| Infrastructure/Internals | `src/infrastructure/internals/` | ~150 | Implémentations concrètes, WebSocket, marshalling |
| Infrastructure/Services | `src/infrastructure/services/` | ~18 | HTTP, Logger, WSS |
| Infrastructure/IO | `src/infrastructure/io/` | 12 | Exceptions |

---

## Hotspots de charge cognitive

### 1. Explosion du système d'événements (70 fichiers → boilerplate × 70)

**Localisation :** `src/domains/events/contracts/{common,private,server}/`

Chaque événement Discord = 1 fichier contrat avec un boilerplate identique :

```dart
abstract class ServerMessageCreateEvent extends BaseListenableEvent {
  @override Event get event => Event.serverMessageCreate;
  FutureOr<void> handle(ServerMessage message);
}
// ... × 69 autres fichiers
```

Ajoutez 45 packet listeners miroirs dans `src/infrastructure/internals/packets/listeners/`.  
**Total : ~115 fichiers pour un mécanisme qui pourrait tenir en 1 registre.**

---

### 2. Résolution IoC dans chaque modèle (~50 fichiers)

```dart
// Répété dans Member, Server, Channel, Role, etc.
DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();
HttpClientContract get _http     => ioc.resolve<HttpClientContract>();
```

Les entités sont couplées au conteneur → non testables en isolation.

---

### 3. Explosion des contextes d'interactions (12+ classes)

`ButtonContext`, `PrivateButtonContext`, `ServerButtonContext`,  
`SelectContext`, `PrivateSelectContext`, `ServerSelectContext`,  
`ModalContext`, `PrivateModalContext`, `ServerModalContext`…

Combinatoire `type × channel` : ajouter un composant = +2 fichiers de contexte.

---

### 4. Barrels surchargés sans frontières de domaine

| Fichier | Exports | Problème |
|---------|---------|---------|
| `api.dart` | 171 | Tout le modèle public exposé à plat |
| `contracts.dart` | ~40 | Mélange contrats service + composants + cache |
| `events.dart` | 70+ | Un export par fichier événement |

---

### 5. Système de commandes fragmenté sur 3 couches

```
api/common/commands/builder/   ← DSL fluent
api/common/commands/           ← CommandContract, CommandDeclaration
domains/commands/              ← CommandHandler (typedef), InteractionManager
```

Cycle de vie illisible : construire, déclarer, enregistrer, dispatcher — chaque étape dans un endroit différent.

---

### 6. Serializers + Factories dupliqués (27 fichiers)

- 16 serializers (`src/infrastructure/internals/marshaller/serializers/`)
- 9 channel factories (`src/infrastructure/internals/marshaller/factories/channels/`)
- 2 message factories

Chaque type Discord = 1 fichier factory + 1 fichier serializer, maintenus manuellement.

---

## Propositions d'amélioration

### P-1 · Registre d'événements générique

**Remplace :** 70 contrats + 45 packet listeners  
**Effort :** Élevé | **Risque :** Moyen (API breaking)

```dart
// Contrat unique
abstract class On<T> {
  FutureOr<void> handle(T payload);
}

// Registre centralisé (1 ligne par événement Discord)
final eventRegistry = EventRegistry({
  Event.serverMessageCreate: (json) => ServerMessage.fromJson(json),
  Event.serverMemberJoin:    (json) => Member.fromJson(json),
});

// Utilisation
class MyListener extends On<ServerMessage> {
  @override FutureOr<void> handle(ServerMessage msg) { ... }
}
```

---

### P-2 · IoC hors des modèles

**Remplace :** ~50 getters `ioc.resolve<>()` dans les entités  
**Effort :** Élevé | **Risque :** Élevé (API breaking)

Les entités deviennent de purs value objects. La logique de mutation passe dans les managers (qui reçoivent leurs dépendances au constructeur).

```dart
// Avant : member.ban() résout ioc en interne
// Après :
class MemberManager {
  final DataStoreContract _datastore;
  MemberManager(this._datastore);
  Future<void> ban(Member member, {String? reason}) => ...;
}
```

---

### P-3 · Contextes d'interactions génériques

**Remplace :** 12 classes de contexte  
**Effort :** Moyen | **Risque :** Moyen

```dart
class InteractionContext<TComponent, TChannel extends Channel> {
  final TComponent component;
  final TChannel channel;
  final Member? member; // null si channel privé
}

// Signature de handler
FutureOr<void> handle(InteractionContext<ButtonComponent, ServerTextChannel> ctx);
```

---

### P-4 · Refactoring des barrels par domaine

**Remplace :** 9 barrels plats avec 350+ exports mélangés  
**Effort :** Faible | **Risque :** Faible

```
lib/
├── mineral.dart            ← point d'entrée unique, ≤6 re-exports
├── src/api/api.dart        ← modèles publics
├── src/events/events.dart  ← types d'événements
├── src/commands/commands.dart
├── src/components/components.dart
└── mineral_testing.dart
```

**Règle :** chaque barrel n'exporte que ce qui est dans son répertoire, jamais d'autres barrels latéralement.

---

### P-5 · Module commandes auto-contenu

**Remplace :** logique dispersée sur 3 couches  
**Effort :** Moyen | **Risque :** Faible

```
src/commands/
├── command.dart            ← CommandDeclaration
├── command_builder.dart    ← DSL fluent
├── command_handler.dart    ← typedef + dispatch
├── command_registry.dart   ← enregistrement + lookup
└── interaction/
    ├── slash_context.dart
    └── autocomplete_context.dart
```

---

### P-6 · ChannelFactory consolidé

**Remplace :** 9 fichiers factory + dispatch manuel  
**Effort :** Faible | **Risque :** Faible

```dart
class ChannelFactory {
  static Channel fromJson(Map<String, dynamic> json) => switch (json['type'] as int) {
    0  => ServerTextChannel.fromJson(json),
    2  => ServerVoiceChannel.fromJson(json),
    13 => ServerStageChannel.fromJson(json),
    _  => throw UnknownChannelTypeException(json['type']),
  };
}
```

Ajouter un type de channel = 1 `case`, pas un nouveau fichier.

---

## Priorisation

| Priorité | ID | Impact cognitif | Effort | Risque | Breaking |
|----------|----|-----------------|--------|--------|----------|
| 1 | P-4 | Élevé | Faible | Faible | Non |
| 2 | P-5 | Élevé | Moyen | Faible | Non |
| 3 | P-6 | Moyen | Faible | Faible | Non |
| 4 | P-3 | Moyen | Moyen | Moyen | Oui |
| 5 | P-1 | Très élevé | Élevé | Moyen | Oui |
| 6 | P-2 | Très élevé | Élevé | Élevé | Oui |

**Recommandation :** commencer par P-4 + P-5 + P-6 (non-breaking, gain immédiat sur la lisibilité) avant d'attaquer P-1 et P-2 qui cassent l'API publique.
