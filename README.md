# Mineral

Mineral is a Dart framework for building Discord bots. It handles the Discord gateway, REST API, and interaction routing so you can focus on your bot's logic.

Everything is organized around **providers**; isolated modules that register commands, events, and components. Each feature lives in its own class, making bots easy to grow and maintain across a team.

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mineral-dart/core)
[![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/fH9UQDMZSn)

---

## Install

```yaml
dependencies:
  mineral: ^4.2.0
```

---

## Quick start

**1. Create a provider**

```dart
// my_provider.dart
final class MyProvider extends Provider {
  final Client _client;

  MyProvider(this._client) {
    _client
      ..register<MyCommand>(MyCommand.new)
      ..register<OnMemberJoin>(OnMemberJoin.new);
  }
}
```

**2. Register and start**

```dart
// main.dart
void main() async {
  final client = ClientBuilder()
    .setIntent(Intent.allNonPrivileged)
    .registerProvider(MyProvider.new)
    .build();

  await client.init();
}
```

---

## Features

### Events

React to anything happening on your Discord server — member joins, message creation, voice state changes, and more. Each event is a dedicated class with a typed `handle()` method.

```dart
final class OnMemberJoin extends ServerMemberAddEvent {
  @override
  Future<void> handle(Member member, Server server) async {
    final channel = await server.channels.resolveSystemChannel();
    await channel?.send(MessageBuilder.text('Welcome, ${member.username}!'));
  }
}
```

### Commands

Slash commands are declared as classes. Each command defines its name, description, and options via `build()`, and handles the interaction in `handle()`. Sub-commands are supported out of the box.

```dart
final class MyCommand implements CommandDeclaration {
  Future<void> handle(ServerCommandContext ctx, CommandOptions options) async {
    final target = options.require<String>('message');
    await ctx.interaction.reply(builder: MessageBuilder.text(target));
  }

  @override
  CommandDeclarationBuilder build() {
    return CommandDeclarationBuilder()
      ..setName('say')
      ..setDescription('Repeat a message')
      ..addOption(Option.string(name: 'message', description: 'Text to repeat', required: true))
      ..setHandle(handle);
  }
}
```

### Buttons & Modals

Interactive components (buttons, modals, select menus) are bound to a `customId`. Mineral routes the interaction to the right handler automatically — no manual dispatch needed.

```dart
final class MyButton extends ServerButtonClickEvent {
  @override
  String? get customId => 'my_button';

  @override
  Future<void> handle(ServerButtonContext ctx) async {
    await ctx.interaction.reply(builder: MessageBuilder.text('Clicked!'));
  }
}
```

### Global State

Share data across your entire bot without passing dependencies manually. Register a state once, read it anywhere via the `State` mixin.

```dart
abstract interface class CounterContract implements GlobalState<int> {
  void increment();
}

final class Counter implements CounterContract {
  int _count = 0;

  @override
  int get state => _count;

  @override
  void increment() => _count++;
}

// Register
client.register<CounterContract>(Counter.new);

// Use (in any handler with the State mixin)
state.read<CounterContract>().increment();
```

---

## Examples

See the [`example/`](example/) directory for complete working bots:

- **welcome** — member join event + button
- **feedback** — slash command + button + modal flow
- **poll** — sub-commands + vote buttons + global state
