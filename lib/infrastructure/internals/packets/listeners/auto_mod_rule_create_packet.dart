import 'package:mineral/api/server/auto_mod/auto_mod_rule.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';
import 'package:mineral/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/internals/wss/shard_message.dart';

final class AutoModRuleCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.autoModRuleCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const AutoModRuleCreatePacket(this.logger, this.marshaller);

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    try {
      final autoModRule = await marshaller.serializers.autoModRule.serialize(message.payload);
      await registerAutoModRule(autoModRule, dispatch);
    } catch (error, stackTrace) {
      logger.error('Failed to process auto mod rule create event', error, stackTrace);
    }
  }

  Future<void> registerAutoModRule(AutoModRule rule, DispatchEvent dispatch) async {
    final server = await marshaller.dataStore.server.getServer(rule.guildId);
    
    // S'assurer que le serveur a une propriété autoModRules.list
    // Définir cela dans la classe Server si ce n'est pas déjà fait
    if (server.autoModRules == null) {
      logger.warn("Server ${server.id} doesn't have autoModRules initialized");
    } else {
      // Ajouter la règle à la liste des règles AutoMod du serveur
      server.autoModRules.list.putIfAbsent(rule.id, () => rule);
    }
    
    // Associer le serveur à la règle
    rule.server = server;
    
    // Mettre à jour le cache
    final rawServer = await marshaller.serializers.server.deserialize(server);
    await marshaller.cache.put(server.id, rawServer);
    
    // Déclencher l'événement
    dispatch(event: Event.autoModRuleCreate, params: [rule]);
  }
}