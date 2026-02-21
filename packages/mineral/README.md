# Mineral - Discord Bot Framework for Dart

![banner](https://raw.githubusercontent.com/mineral-dart/core/develop/assets/images/banner.png)

Mineral meets a need for scalability over time but also within a team of developers thanks to a modular and flexible software architecture. modular and flexible software architecture.

Don't reinvent the wheel, the framework facilitates the sharing and accessibility of your data across your entire of your application. Design modules that can be reused in several of your projects.

We want to make your life easier, Mineral provides you with dedicated classes for each of the following features of Discord: events, commands, context menus, etc...

In order to improve your development experience, we wanted to integrate some features that do not exist in Discord but are very interesting but very interesting features such as intra-application data sharing through the Stores, a bunch of additional events around your discord servers or access in only one and 2 lines of code to an API through official Dart packages delivering recurring features such as tickets recurring features such as tickets, invitations or voice chancels on demand.

With Mineral, you can unleash the full potential of your bot and bring your Discord server to life.

## Key Features

### Command Handling

Commands in Mineral serve the purpose of defining specific actions that your bot can perform in response to a given command. 
They allow users to communicate with your bot and interact with it in a structured way.

```dart
class HelloWorldCommand extends MineralCommand<GuildCommandInteraction> {
  HelloWorldCommand(): super(
    label: Display('hello'),
    description: Display('Add new member to the ticket !'),
    options: [
      CommandOption.user(Display('member'), Display('The member to add to the ticket !'))
    ]
  );

  Future<void> handle (interaction) async {
    final targetMember = interaction.getMember('member');

    await interaction.reply(
      content: 'Hello $targetMember',
      private: true
    );
  }
}
```

### Event Listeners
Commands in Mineral serve the purpose of defining specific actions that your bot can perform in response to a given command. 
They allow users to communicate with your bot and interact with it in a structured way.

By utilizing events, you can create dynamic and interactive experiences within your Discord bot. 
Events allow you to capture and respond to various actions and changes happening in real-time, enabling your bot to adapt and provide relevant functionality based on the events occurring in the Discord environment.

```dart
class Ready extends MineralEvent<ReadyEvent> with Console {
  Future<void> handle (event) async {
    console.info('${event.client.user.username} is ready to use !');
  }
}
```

### Interactive Components
By utilizing events, you can create dynamic and interactive experiences within your Discord bot. 
Events allow you to capture and respond to various actions and changes happening in real-time, enabling your bot to adapt and provide relevant functionality based on the events occurring in the Discord environment.

By incorporating interactive components into your Discord bot, you can enhance user engagement and provide a more interactive and dynamic experience. They allow users to interact with your bot directly within messages, enabling them to perform actions, make choices, and receive real-time feedback. Interactive components add an extra layer of interactivity to your bot's functionality and can greatly enhance the user experience.

Interactive components enhance the way buttons are used in Discord bots by introducing interactivity and real-time feedback.

A single file allows you to design your composanbt and attach a dedicated handler when the user interacts with it.

```dart
class MyButton extends InteractiveButton {
  MyButton(): super('my-id');

  @override
  Future<void> handle (ButtonCreateEvent event) async {
    await event.interaction.reply(
      content: 'Hello Mineral !', 
      private: true
    );
  }

  @override
  ButtonBuilder build () => ButtonBuilder.button(customId)
    ..setLabel('Mineral')
    ..setStyle(ButtonStyle.primary);
}
```

### State Management
Share and manage data across your bot using shared states.

```dart
class MyState extends MineralState<int> {
  MyState() : super(0);

  void increment() => state++;

  void decrement() => state--;
}
```

- **HTTP API Integration:** Seamlessly interact with the Discord API to perform actions such as sending messages, updating user information, creating channels, and more.

- **Container and Dependency Injection:** Take advantage of the powerful dependency injection capabilities provided by Mineral's built-in container, making it easy to manage and access your services and dependencies.

- **Error Handling and Logging:** Benefit from robust error handling and logging mechanisms to ensure smooth operation and easy debugging of your bot.

- **Extensible Architecture:** Extend and customize Mineral to fit your specific needs with ease. The framework provides a modular and extensible architecture that allows for easy integration of custom modules and plugins.

## Community and Support
Join our vibrant community of Discord bot developers on Discord to get support, share your projects, and collaborate with other developers.

We also encourage you to contribute to the Mineral project by reporting issues, suggesting new features, or submitting pull requests on GitHub.

Start your journey with Mineral today and create extraordinary Discord bots that will elevate your server to new heights!

[![Discord](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/mineral-dart/core)
[![Discord](https://img.shields.io/badge/Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/fH9UQDMZSn)
[![Tiktok](https://img.shields.io/badge/Tiktok-000000?style=for-the-badge&logo=tiktok&logoColor=white)]()
