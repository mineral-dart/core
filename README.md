![License](https://img.shields.io/github/license/mineral-dart/core.svg)
![Stars](https://img.shields.io/github/stars/mineral-dart)
![Pull request](https://img.shields.io/github/issues-pr-closed/mineral-dart/core.svg)
![Made with](https://img.shields.io/badge/Made%20with-dart-0866a8.svg)

![banner](https://raw.githubusercontent.com/mineral-dart/core/develop/assets/images/banner.png)

## The concepts
Mineral meets a need for scalability over time but also within a team of developers thanks to a modular and flexible software architecture.
modular and flexible software architecture.

Don't reinvent the wheel, the framework facilitates the sharing and accessibility of your data across your entire
of your application. Design modules that can be reused in several of your projects.

We want to make your life easier, Mineral provides you with dedicated classes for each of the following features of
Discord: events, commands, context menus, etc...

In order to improve your development experience, we wanted to integrate some features that do not exist in Discord but are very interesting
but very interesting features such as intra-application data sharing through the
Stores, a bunch of additional events around your discord servers or access in only one
and 2 lines of code to an API through official Dart packages delivering recurring features such as tickets
recurring features such as tickets, invitations or voice chancels on demand.

## Mineral tour
### The events

They are the heart of any Discord application, events allow you to act at a point in your application's lifecycle when an action is performed on the Discord server where your application is present.
```dart
import 'package:mineral/framework.dart';
import 'package:mineral/core/events';

class MessageReceived extends MineralEvent<MessageCreate> {
  Future<void> handle (Message message) async {
    if (!message.author.isBot) {
      await message.reply(content: 'Hello ${message.author} ! 👋');
    }
  }
}
```

In order to simplify the association between a component (buttons, selection menus...) and its resulting action, you can define a customId key in order to execute your code only if the given interaction is the right one.

Consider the component displaying buttons below :
```dart
final button = ButtonBuilder(
  label: 'My buttton',
  customId: 'my-custom-id',
  style: ButtonStyle.primary   
);
```

### The slash commands
Since version 8 of the websocket, Discord have announced their willingness to migrate traditional commands designed with the MessageCreate event to dedicated components that we call clash commands.

To simplify their design, we provide you with dedicated classes, please consider the examples below.
```dart
import 'package:mineral/framework.dart';
import 'package:mineral/core/api.dart';

class HelloCommand extends MineralCommand {
  HelloCommand() {
    register(CommandBuilder('hello', 'Say hello to everyone !', scope: Scope.guild));
  }
  
  Future<void> handle (CommandInteraction interaction) async {
    final Role everyone = interaction.guild?.roles.everyone;
    
    await interaction.reply(content: 'Hello $everyone');
  }
}
```

### The menu context
Since the introduction of the new command management system, Discord has also introduced a very interesting feature that allows you to perform an action by taking as a source not a command to be written in the chat, but through a user or a message (very useful to postpone a user or a moved message).

In order to fully exploit this functionality, a specific class is created.
```dart
import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ContextMenu extends MineralContextMenu {
  ContextMenu () {
    register('message-context', ContextMenuType.message);
  }

  @override
  Future<void> handle(Message message) async {
    await message.reply(content: message.content);
  }
}
```

### Data sharing

The Discord.js documentation advocates in its examples the use of the very bad practice of only developing in a single file that contains your entire Discord application.

Working with this principle allows each of your listeners to use variables defined within the same file, so it is very easy to share data across multiple listeners.

The Mineral framework forces you to design your application following the S principle of the SOLID acronym in order to respect the principle of "single responsibility" (each class/function must perform only one action) which allows to obtain a better scalability in time and at the same time to limit to the maximum the repetition/duplication of code.

The use of this architecture implies that it becomes difficult to share states across your different classes.

In order to facilitate this sharing, the framework offers you the possibility to design classes dedicated to this need thanks to the @Store decorator.

```dart
import 'package:mineral/framework.dart';

class MyState extends MineralState<List<int>> {
  MyState(): super('MyState', 'MyState description');

  // Add string to this
  void addItem (int value) => state.add(value);
  
  // Verify if this contains given value
  bool has (int value) => state.contains(value);
}
```

When you register your class in your hand, your blind is accessible from any command, event or context menu file.

`main.dart`
```dart
Future<void> main () async {
  Kernel kernel = Kernel()
    ..intents.defined(all: true)
    ..events.register([MessageReceived()])
    ..stores.register([MyState()]);
  
  await kernel.init();
}
```

Now that your store is registered within your application, you can now access your shared state using the code below, we will illustrate the operation on the MessageCreate event.
```dart
import 'package:mineral/framework.dart';
import 'package:mineral/core/events';

class MessageCreate extends MineralEvent<MessageCreate> {
  Future<void> handle (Message message) async {
    final myState = states.use<MyStore>();
    myState.addItem(1);
    
    Console.info(message: 'MyState contains ${store.state.length} items.');
  }
}
```

Join our ranks and add your contribution to the best discord framework for Dart 💪

[![Discord](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mineral-dart/core)
[![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/fH9UQDMZSn)
[![Tiktok](https://img.shields.io/badge/Tiktok-000000?style=for-the-badge&logo=tiktok&logoColor=white)]()
