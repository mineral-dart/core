# Mineral Test

`mineral_test` is the official testing toolkit for [Mineral](https://github.com/mineral-dart/core) bots. It boots an in-memory bot — **no WebSocket, no HTTP** — and gives you a recorder, simulators, builders, matchers, and a fluent DSL so you can assert on what your bot _does_, not how it does it.

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mineral-dart/core)
[![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/fH9UQDMZSn)

---

## Install

```yaml
dev_dependencies:
  mineral_test: ^0.1.0
  test: ^1.28.0
```

---

## Quick start

```dart
import 'package:mineral_test/mineral_test.dart';
import 'package:test/test.dart';

void main() {
  late TestBot bot;

  setUp(() async => bot = await TestBot.create());
  tearDown(() => bot.dispose());

  test('replies with pong', () async {
    bot.events.register(PingListener());

    await bot.simulateCommand('ping', invokedBy: UserBuilder().build());

    expect(
      bot.actions.interactionReplies,
      contains(isInteractionReplied(content: 'pong')),
    );
  });
}
```

That's the whole loop: **register → simulate → assert**.

---

## Concepts

### TestBot

`TestBot.create()` boots an isolated kernel that wires up `LoggerContract`, `HttpClientContract`, `MarshallerContract`, and `DataStoreContract` on a fresh IoC scope. Every side-effect a handler produces (sending messages, banning members, assigning roles) flows through a recording HTTP client and shows up under `bot.actions`.

Always call `bot.dispose()` in `tearDown` — it restores the previous global IoC container.

### Listeners

Tests don't run the full Mineral dispatcher; they invoke lightweight, framework-agnostic listeners directly. Subclass one of:

- `OnCommandListener` — slash command (`command` getter)
- `OnButtonListener` — button click (`customId` getter)
- `OnModalSubmitListener` — modal submission (`customId` getter)
- `OnMemberJoinListener` — member join

```dart
final class PingListener extends OnCommandListener {
  @override
  String get command => 'ping';

  @override
  Future<void> handle(CommandInvocation invocation) async {
    await TestInteractionResponder.reply(
      interactionId: invocation.interactionId,
      token: invocation.token,
      content: 'pong',
    );
  }
}
```

Register with `bot.events.register(PingListener())`.

### Builders

Construct test payloads fluently:

```dart
final user = UserBuilder()
  .withUsername('alice')
  .asBot()
  .build();

final guild = GuildBuilder()
  .withName('Mineral HQ')
  .build();

final role = RoleBuilder()
  .withName('Member')
  .ofGuild(guild)
  .build();

final member = MemberBuilder()
  .ofGuild(guild)
  .withUser(user)
  .withRole(role)
  .build();

final channel = ChannelBuilder()
  .ofGuild(guild)
  .withName('general')
  .build();
```

Every builder generates a snowflake-shaped id when you don't supply one.

### Simulators

```dart
await bot.simulateCommand('echo',
    options: {'message': 'hi'}, invokedBy: user);

await bot.simulateButton('vote_yes', clickedBy: user);

await bot.simulateModalSubmit('feedback',
    submittedBy: user, fields: {'comment': 'nice'});

await bot.simulateMemberJoin(member: member, guild: guild);
```

Handler exceptions don't crash the test — they're captured in `bot.errors` as `HandlerError(error, stackTrace, commandName/customId/eventName)`.

### Recorders

Everything observable lives under `bot.actions`:

| Property             | Type                                          |
| -------------------- | --------------------------------------------- |
| `sentMessages`       | `List<SentMessage>`                           |
| `interactionReplies` | `List<InteractionReply>`                      |
| `modals`             | `List<ModalShown>`                            |
| `bans`               | `List<MemberBanned>`                          |
| `roleAssignments`    | `List<RoleAssigned>`                          |
| `roleRemovals`       | `List<RoleRemoved>`                           |
| `messageEdits`       | `List<MessageEdited>`                         |
| `messageDeletions`   | `List<MessageDeleted>`                        |
| `all`                | every `RecordedAction` in chronological order |

### Matchers

Each recorder has a paired matcher; every field is optional and accepts either a literal or a `Matcher`:

```dart
expect(bot.actions.sentMessages,
    contains(isMessageSent(channelId: 'general', content: 'hello')));

expect(bot.actions.sentMessages,
    contains(isMessageSent(content: contains('hello'))));

expect(bot.actions.interactionReplies,
    contains(isInteractionReplied(content: 'pong', ephemeral: false)));

expect(bot.actions.bans,
    contains(isMemberBanned(memberId: target.id, reason: 'spam')));

expect(bot.actions.roleAssignments,
    contains(isRoleAssigned(memberId: member.id, roleId: role.id)));

expect(bot.actions.modals,
    contains(isModalShown(customId: 'feedback', title: 'Tell us more')));
```

Available matchers: `isMessageSent`, `isInteractionReplied`, `isModalShown`, `isMemberBanned`, `isRoleAssigned`, `isRoleRemoved`.

### Data store

Seed in-memory state and assert on it after a handler ran:

```dart
bot.dataStore.seed(
  guilds: [guild],
  roles: [memberRole],
  members: [member],
);

await bot.simulateMemberJoin(member: member, guild: guild);

final updated = bot.dataStore.member(member.id, in_: guild);
expect(updated.roles, contains(memberRole));
```

The store auto-applies recorded actions: a `RoleAssigned` adds the role to the seeded member, `MemberBanned` removes them, etc.

### Fluent DSL

For the common register-then-assert flow:

```dart
await bot.whenCommand('ping')
    .invokedBy(user)
    .expectReply(content: 'pong');

await bot.whenButton('vote_yes')
    .clickedBy(user)
    .expectModal(customId: 'feedback');

await bot.whenModalSubmit('feedback')
    .withFields({'comment': 'great'})
    .submittedBy(user)
    .expectReply(content: contains('thanks'));

await bot.whenMemberJoins(guild)
    .forMember(member)
    .expectRoleAssigned(roleId: memberRole.id);
```

---

## Examples

See [`example/`](example/) for full bot listeners and matching tests:

- **ping_command** — simple replies, option parsing, error capture
- **welcome_listener** — sending a message into a channel on member join
- **auto_role_listener** — assigning a role on join, asserting both the action and the resulting store state
- **mod_command** — authorization, ephemeral replies, banning members
- **poll_buttons** — button → modal → reply flow
