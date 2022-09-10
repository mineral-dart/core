![License](https://img.shields.io/github/license/mineral-dart/core.svg)
![Stars](https://img.shields.io/github/stars/mineral-dart/core.svg)
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
@Event(Events.messageCreate)
class RecievedMessages extends MineralEvent {
  Future<void> handle (Message message) async {
    // Your code here
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
The customId of the button is my-custom-id, if we want to perform an action, we can filter incoming events by specifying the customId in the decorator of your event file.

```dart
@Event(Events.messageCreate, customId: 'my-custom-id') 👈
class RecievedMessages extends MineralEvent {
  Future<void> handle (Message message) async {
    // Your code for your button action
  }
}
```

### The slash commands
Since version 8 of the websocket, Discord have announced their willingness to migrate traditional commands designed with the MessageCreate event to dedicated components that we call clash commands.

To simplify their design, we provide you with dedicated classes, please consider the examples below.
```dart
@Command(label: 'hello', description: 'Say Hello World !', scope: 'GUILD')
class HelloCommand extends MineralCommand {
  Future<void> handle (CommandInteraction interaction) async {
    await interaction.reply(content: 'Hello World !');
  }
}
```

A command that does not have an option is usually problematic depending on what you want to do with it. You can set options to your commands using a dedicated decorator which applies to both classes and methods, but we'll come back to that later.
```dart
@Command(label: 'hello', description: 'Say Hello World !', scope: 'GUILD')
@Option(label: 'member', description: 'Target member', type: OptionType.member, required: true)
class HelloCommand extends MineralCommand {
  Future<void> handle (CommandInteraction interaction) async {
    final GuildMember? member = interaction.data.getMember('member');
    await interaction.reply(content: 'Hello $member !');
  }
}
```


### The sub-commands

In the update implementing clash commands, Discord also gave us the possibility to design sub-commands and groups of sub-commands. Implementing them is generally complex to understand because it requires designing very large objects that are nested within each other...

In order to improve the user experience but to cover as many cases as possible, we are allowing you to fully exploit the Discord API through new decorators, which you can discover below.
```dart
@Command(label: 'hello', description: 'Say Hello World !', scope: 'GUILD')
class HelloCommand extends MineralCommand {
  @Subcommand(label: 'subcommand', description: 'Subcommand description') 👈
  Future<void> subcommand (CommandInteraction interaction) async {
    await interaction.reply(content: 'Hello World !');
  }
}
```

It is important to note that the name of the method must be identical to the one defined in the label of your sub-command, otherwise it will simply fail.

If you still want to set a different label to your method name, you can force the assignment using the bind parameter in the decorator of your sub-command.
```dart
@Command(label: 'hello', description: 'Say Hello World !', scope: 'GUILD')
class HelloCommand extends MineralCommand {
  @Subcommand(label: 'sub-command', description: '...', bind: 'sub')👈
  Future<void> sub (CommandInteraction interaction) async {
    await interaction.reply(content: 'Hello World !');
  }
}
```


### The sub-command groups

Easily group your sub-commands into groups with your dedicated decorator.
```dart
@Command(label: 'hello', description: 'Say Hello World !', scope: 'GUILD')
@CommandGroup(label: 'group', description: 'Group description') 👈
class HelloCommand extends MineralCommand {
  @Subcommand(group: 'group', label: 'subcommand', description: '...') 👈
  Future<void> subcommand (CommandInteraction interaction) async {
    await interaction.reply(content: 'Hello World !');
  }
}
```

### The menu context
Since the introduction of the new command management system, Discord has also introduced a very interesting feature that allows you to perform an action by taking as a source not a command to be written in the chat, but through a user or a message (very useful to postpone a user or a moved message).

In order to fully exploit this functionality, a specific class is created.
```dart
@ContextMenu(
  name: 'my-message',
  description: '...',
  scope: 'GUILD',
  type: ContextMenuType.message // 👈 Ou ContextMenuType.user
)
class MessageContext extends MineralContextMenu {
  Future<void> handle (ContextMessageInteraction interaction) async {
    await interaction.reply(content: interaction.message.content);
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
@Store(name: 'my-store')
class MyStore extends MineralStore<T extends String> {
  List<T> state = [];
  
  // Add string to this
  void addItem (T value) => state.add(value);
  
  // Verify if this contains given value
  bool has (T value) => state.contains(value);
}
```

When you register your class in your hand, your blind is accessible from any command, event or context menu file.

`main.dart`
```dart
Future<void> main () async {
  Kernel kernel = Kernel()
    ..intents.defined(all: true)
    ..events.register([MessageCreate()])
    ..stores.register([MyStore()]);
  
  await kernel.init();
}
```

Now that your store is registered within your application, you can now access your shared state using the code below, we will illustrate the operation on the MessageCreate event.
```dart
@Event(Events.messageCreate)
class MessageCreate {
  Future<void> handle (Message message) async {
    final store = stores.getStore<MyStore>('my-store');
    store.addItem('Hello World !');
    
    Console.info(message: 'MyStore contains ${store.state.length} items.');
  }
}
```

Join our ranks and add your contribution to the best discord framework for Dart 💪

[![Discord](https://img.shields.io/badge/Discord-7289DAstyle=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/fH9UQDMZSn)
[![Discord](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mineral-dart/core)
