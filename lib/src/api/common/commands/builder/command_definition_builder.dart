import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/commands/builder/command_declaration_builder.dart';
import 'package:mineral/src/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/src/api/common/commands/builder/translation.dart';
import 'package:mineral/src/api/common/commands/command_choice_option.dart';
import 'package:mineral/src/api/common/commands/command_option.dart';
import 'package:mineral/src/api/common/lang.dart';
import 'package:mineral/src/domains/commands/command_builder.dart';
import 'package:yaml/yaml.dart';

/// A declarative builder for constructing Discord slash commands from configuration files.
///
/// The [CommandDefinitionBuilder] enables you to define command structures using external
/// YAML or JSON files, separating command declarations from handler logic. This approach
/// is ideal for managing complex command hierarchies, supporting multiple languages, and
/// maintaining command definitions independently from code.
///
/// ## Key Features
///
/// - **File-Based Configuration**: Define commands in YAML or JSON files
/// - **Localization Support**: Automatic translation extraction for multiple languages
/// - **Command Hierarchies**: Support for commands, subcommands, and groups
/// - **Type-Safe Options**: Comprehensive option types including choices
/// - **Handler Mapping**: Connect configuration keys to handler functions
/// - **Placeholder Support**: Dynamic configuration with custom placeholders
/// - **Validation**: Built-in validation of command structure
///
/// ## Configuration File Format
///
/// Configuration files can be written in YAML or JSON and follow this structure:
///
/// ```yaml
/// commands:
///   greet:
///     name:
///       _default: greet
///       en: greet
///       fr: saluer
///       es: saludar
///     description:
///       _default: Greet a user
///       en: Greet a user
///       fr: Saluer un utilisateur
///       es: Saludar a un usuario
///     options:
///       - name:
///           _default: target
///         description:
///           _default: User to greet
///         type: user
///         required: true
/// ```
///
/// ## Usage
///
/// ### Basic Example
///
/// **command.yaml**:
/// ```yaml
/// commands:
///   ping:
///     name:
///       _default: ping
///     description:
///       _default: Check bot latency
/// ```
///
/// **Dart code**:
/// ```dart
/// final class PingCommand implements CommandDefinition {
///   @override
///   CommandDefinitionBuilder build() {
///     return CommandDefinitionBuilder()
///       ..using(File('assets/commands/ping.yaml'))
///       ..setHandler('ping', (CommandContext ctx) {
///         ctx.interaction.reply(
///           builder: MessageBuilder.text('Pong!'),
///         );
///       });
///   }
/// }
/// ```
///
/// Register the command:
/// ```dart
/// final client = ClientBuilder()
///   .build();
/// 
/// client.register(PingCommand.new);
/// await client.init();
/// ```
///
/// ### Command with Options
///
/// **greet.yaml**:
/// ```yaml
/// commands:
///   greet:
///     name:
///       _default: greet
///       en: greet
///       fr: saluer
///     description:
///       _default: Greet a user
///       en: Greet a user
///       fr: Saluer un utilisateur
///     options:
///       - name:
///           _default: target
///         description:
///           _default: User to greet
///         type: user
///         required: true
///       - name:
///           _default: message
///         description:
///           _default: Custom message
///         type: string
///         required: false
/// ```
///
/// **Dart code**:
/// ```dart
/// final class GreetCommand implements CommandDefinition {
///   @override
///   CommandDefinitionBuilder build() {
///     return CommandDefinitionBuilder()
///       ..using(File('assets/commands/greet.yaml'))
///       ..setHandler('greet', handle);
///   }
///   
///   void handle(
///     CommandContext ctx, {
///     required User target,
///     String? message,
///   }) {
///     final greeting = message ?? 'Hello';
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('$greeting, ${target.username}!'),
///     );
///   }
/// }
/// ```
///
/// ### Commands with Subcommands
///
/// **todo.yaml**:
/// ```yaml
/// commands:
///   todo:
///     name:
///       _default: todo
///     description:
///       _default: Manage tasks
///   
///   todo.add:
///     name:
///       _default: add
///     description:
///       _default: Add a task
///     options:
///       - name:
///           _default: task
///         description:
///           _default: Task description
///         type: string
///         required: true
///   
///   todo.list:
///     name:
///       _default: list
///     description:
///       _default: List all tasks
/// ```
///
/// **Dart code**:
/// ```dart
/// final class TodoCommand implements CommandDefinition {
///   @override
///   CommandDefinitionBuilder build() {
///     return CommandDefinitionBuilder()
///       ..using(File('assets/commands/todo.yaml'))
///       ..setHandler('todo.add', addTask)
///       ..setHandler('todo.list', listTasks);
///   }
///   
///   void addTask(CommandContext ctx, {required String task}) {
///     // Add task logic
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Added: $task'),
///     );
///   }
///   
///   void listTasks(CommandContext ctx) {
///     // List tasks logic
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Your tasks...'),
///     );
///   }
/// }
/// ```
///
/// ### Command Groups
///
/// **admin.yaml**:
/// ```yaml
/// groups:
///   user:
///     name:
///       _default: user
///     description:
///       _default: User management
///   role:
///     name:
///       _default: role
///     description:
///       _default: Role management
///
/// commands:
///   admin:
///     name:
///       _default: admin
///     description:
///       _default: Administrative commands
///   
///   admin.user.ban:
///     group: user
///     name:
///       _default: ban
///     description:
///       _default: Ban a user
///     options:
///       - name:
///           _default: target
///         description:
///           _default: User to ban
///         type: user
///         required: true
///   
///   admin.role.create:
///     group: role
///     name:
///       _default: create
///     description:
///       _default: Create a role
/// ```
///
/// **Dart code**:
/// ```dart
/// final class AdminCommand implements CommandDefinition {
///   @override
///   CommandDefinitionBuilder build() {
///     return CommandDefinitionBuilder()
///       ..using(File('assets/commands/admin.yaml'))
///       ..setHandler('admin.user.ban', banUser)
///       ..setHandler('admin.role.create', createRole);
///   }
///   
///   void banUser(ServerCommandContext ctx, {required User target}) {
///     // Ban user logic
///   }
///   
///   void createRole(ServerCommandContext ctx) {
///     // Create role logic
///   }
/// }
/// ```
///
/// ### Choice Options
///
/// **config.yaml**:
/// ```yaml
/// commands:
///   config:
///     name:
///       _default: config
///     description:
///       _default: Configure settings
///     options:
///       - name:
///           _default: theme
///         description:
///           _default: Choose theme
///         type: choice.string
///         required: true
///         choices:
///           - name: Light
///             value: light
///           - name: Dark
///             value: dark
///           - name: Auto
///             value: auto
/// ```
///
/// ### Using Placeholders
///
/// **command.yaml**:
/// ```yaml
/// commands:
///   version:
///     name:
///       _default: version
///     description:
///       _default: Show bot version {{VERSION}}
/// ```
///
/// **Dart code**:
/// ```dart
/// final class VersionPlaceholder implements PlaceholderContract {
///   @override
///   String apply(String content) {
///     return content.replaceAll('{{VERSION}}', '1.0.0');
///   }
/// }
///
/// final builder = CommandDefinitionBuilder()
///   ..using(
///     File('assets/commands/version.yaml'),
///     placeholder: VersionPlaceholder(),
///   );
/// ```
///
/// ## Configuration Structure
///
/// ### Required Fields
///
/// Each command must have:
/// - `name._default`: Default command name
/// - `description._default`: Default command description
///
/// ### Optional Fields
///
/// - `name.<lang>`: Localized command names
/// - `description.<lang>`: Localized descriptions
/// - `options`: Array of command options
/// - `group`: Group name (for grouped subcommands)
///
/// ### Supported Option Types
///
/// - `string` - Text input
/// - `integer` - Whole numbers
/// - `double` - Decimal numbers
/// - `boolean` - True/false values
/// - `user` - User selection
/// - `channel` - Channel selection
/// - `role` - Role selection
/// - `mention` - User or role selection
/// - `choice.string` - String choices
/// - `choice.integer` - Integer choices
/// - `choice.double` - Double choices
///
/// ### Supported Languages
///
/// All language codes from [Lang] enum are supported, including:
/// - `en`, `fr`, `es`, `de`, `it`, `pt-BR`, `ja`, `zh-CN`, `ko`
/// - And many more (see [Lang] for complete list)
///
/// ## Command Key Format
///
/// Commands use dot-notation keys:
///
/// - `commandname` - Top-level command
/// - `parent.subcommand` - Subcommand
/// - `parent.group.subcommand` - Grouped subcommand
///
/// These keys are used in [setHandler] and [context] methods.
///
/// ## JSON Format
///
/// The same structure works in JSON:
///
/// ```json
/// {
///   "commands": {
///     "greet": {
///       "name": {
///         "_default": "greet",
///         "fr": "saluer"
///       },
///       "description": {
///         "_default": "Greet a user",
///         "fr": "Saluer un utilisateur"
///       },
///       "options": [
///         {
///           "name": { "_default": "target" },
///           "description": { "_default": "User to greet" },
///           "type": "user",
///           "required": true
///         }
///       ]
///     }
///   }
/// }
/// ```
///
/// ## Benefits
///
/// - **Separation of Concerns**: Keep command structure separate from logic
/// - **Easy Localization**: Manage translations in one place
/// - **Non-Developer Friendly**: Command structure editable without code changes
/// - **Version Control**: Track command structure changes independently
/// - **Reusability**: Share command definitions across projects
/// - **Validation**: Early detection of structure issues
/// - **Scalability**: Manage large command sets efficiently
///
/// ## Best Practices
///
/// - **Organize files**: Use one file per command or command group
/// - **Consistent naming**: Follow dot-notation conventions
/// - **Default values**: Always provide `_default` entries
/// - **Translation coverage**: Translate all user-facing text
/// - **Type accuracy**: Use correct option types
/// - **Required ordering**: Put required options before optional ones
/// - **Clear descriptions**: Write helpful, concise descriptions
/// - **Group logically**: Use groups for related subcommands
///
/// ## vs Other Builders
///
/// Use [CommandDefinitionBuilder] (via [CommandDefinition] contract) when you need:
/// - File-based command configuration
/// - Easy management of complex command hierarchies
/// - Separation of structure from logic
/// - Non-developer editing of command structure
/// - Large command sets with many subcommands
///
/// Use [CommandDeclarationBuilder] (via [CommandDeclaration] contract) when you need:
/// - Programmatic command creation with localization
/// - Modular subcommands via [SubCommandDeclaration]
/// - Full control in code with Translation support
///
/// Use [CommandBuilder] (functional approach) when you need:
/// - Simple, non-localized commands
/// - Quick prototyping
/// - Minimal command setup
///
/// See also:
/// - [CommandDefinition] for the command definition contract interface
/// - [CommandDeclarationBuilder] for programmatic command building
/// - [CommandBuilder] for basic command building
/// - [Translation] for localization configuration
/// - [PlaceholderContract] for custom placeholder support
/// - [SubCommandBuilder] for building subcommands
/// - [CommandGroupBuilder] for organizing command groups
/// - [CommandDeclaration] for the command declaration contract
/// - [Lang] for supported language codes
final class CommandDefinitionBuilder implements CommandBuilder {
  final String _defaultIdentifier = '_default';

  final Map<String, dynamic Function()> _commandMapper = {};
  final CommandDeclarationBuilder command = CommandDeclarationBuilder();

  /// Provides access to a specific command or subcommand for advanced configuration.
  ///
  /// This method allows you to access the builder instance for a specific command
  /// identified by its key, enabling advanced modifications beyond what's available
  /// in the configuration file.
  ///
  /// The command key follows dot-notation:
  /// - `commandname` for top-level commands
  /// - `parent.subcommand` for subcommands
  /// - `parent.group.subcommand` for grouped subcommands
  ///
  /// ## Examples
  ///
  /// ### Modify command context
  /// ```dart
  /// builder.context<CommandDeclarationBuilder>('admin', (command) {
  ///   command.setContext(CommandContextType.server);
  /// });
  /// ```
  ///
  /// ### Add dynamic options to subcommand
  /// ```dart
  /// builder.context<SubCommandBuilder>('todo.add', (command) {
  ///   command.addOption(Option.string(
  ///     name: 'priority',
  ///     description: 'Task priority',
  ///     required: false,
  ///   ));
  /// });
  /// ```
  ///
  /// ### Configure multiple subcommands
  /// ```dart
  /// builder
  ///   ..context<SubCommandBuilder>('manage.add', (cmd) {
  ///     cmd.addOption(Option.integer(name: 'amount', description: 'Amount'));
  ///   })
  ///   ..context<SubCommandBuilder>('manage.remove', (cmd) {
  ///     cmd.addOption(Option.integer(name: 'amount', description: 'Amount'));
  ///   });
  /// ```
  ///
  /// Parameters:
  /// - [key]: The command key in dot-notation
  /// - [fn]: A callback function receiving the command builder
  ///
  /// The generic type [T] should be either [CommandDeclarationBuilder] for
  /// top-level commands or [SubCommandBuilder] for subcommands.
  ///
  /// Throws [StateError] if the command key is not found.
  void context<T>(String key, Function(T) fn) {
    final command =
        _commandMapper.entries.firstWhere((element) => element.key == key);
    fn(command.value());
  }

  /// Sets the handler function for a specific command or subcommand.
  ///
  /// This method connects a command key from the configuration file to its
  /// corresponding handler function. The handler is called when users invoke
  /// the command in Discord.
  ///
  /// The command key follows dot-notation:
  /// - `commandname` for top-level commands
  /// - `parent.subcommand` for subcommands
  /// - `parent.group.subcommand` for grouped subcommands
  ///
  /// Handler functions must have [CommandContext] (or [ServerCommandContext]/
  /// [GlobalCommandContext]) as the first parameter, followed by named parameters
  /// that match the command's options.
  ///
  /// ## Examples
  ///
  /// ### Simple command handler
  /// ```dart
  /// builder.setHandler('ping', (CommandContext ctx) {
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text('Pong!'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Handler with required parameters
  /// ```dart
  /// builder.setHandler('greet', (
  ///   CommandContext ctx, {
  ///   required User target,
  ///   String? message,
  /// }) {
  ///   final greeting = message ?? 'Hello';
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text('$greeting, ${target.username}!'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Subcommand handlers
  /// ```dart
  /// builder
  ///   ..setHandler('todo.add', (CommandContext ctx, {required String task}) {
  ///     // Add task
  ///     ctx.interaction.reply(
  ///       builder: MessageBuilder.text('Added: $task'),
  ///     );
  ///   })
  ///   ..setHandler('todo.list', (CommandContext ctx) {
  ///     // List tasks
  ///     ctx.interaction.reply(
  ///       builder: MessageBuilder.text('Your tasks...'),
  ///     );
  ///   });
  /// ```
  ///
  /// ### Server-specific handler
  /// ```dart
  /// builder.setHandler('admin.user.ban', (
  ///   ServerCommandContext ctx,
  ///   {required User target},
  /// ) {
  ///   final guild = ctx.guild;
  ///   // Ban user from guild
  /// });
  /// ```
  ///
  /// ### Async handler with defer
  /// ```dart
  /// builder.setHandler('search', (
  ///   CommandContext ctx,
  ///   {required String query},
  /// ) async {
  ///   await ctx.interaction.defer();
  ///   
  ///   final results = await performSearch(query);
  ///   
  ///   await ctx.interaction.editReply(
  ///     builder: MessageBuilder.text('Found ${results.length} results'),
  ///   );
  /// });
  /// ```
  ///
  /// Parameters:
  /// - [key]: The command key in dot-notation
  /// - [fn]: The handler function to execute when the command is invoked
  ///
  /// Throws [StateError] if the command key is not found.
  ///
  /// See also:
  /// - [CommandContext] for interaction handling
  /// - [ServerCommandContext] for server-specific commands
  /// - [GlobalCommandContext] for global commands
  void setHandler(String key, Function fn) {
    final command =
        _commandMapper.entries.firstWhere((element) => element.key == key);

    switch (command.value()) {
      case final SubCommandBuilder command:
        command.setHandle(fn);
      case final CommandDeclarationBuilder command:
        command.setHandle(fn);
    }
  }

  /// Loads and processes a command definition from a configuration file.
  ///
  /// This method reads a YAML or JSON configuration file and builds the complete
  /// command structure, including localization, options, subcommands, and groups.
  /// The file format is automatically detected from the file extension.
  ///
  /// After calling this method, use [setHandler] to attach handler functions to
  /// the defined commands, then access [command] to get the fully built command.
  ///
  /// ## Supported File Formats
  ///
  /// - `.yaml` - YAML format
  /// - `.yml` - YAML format
  /// - `.json` - JSON format
  ///
  /// ## Examples
  ///
  /// ### Basic YAML file
  /// ```dart
  /// final builder = CommandDefinitionBuilder()
  ///   ..using(File('assets/commands/ping.yaml'));
  /// ```
  ///
  /// ### JSON file
  /// ```dart
  /// final builder = CommandDefinitionBuilder()
  ///   ..using(File('assets/commands/greet.json'));
  /// ```
  ///
  /// ### With placeholders
  /// ```dart
  /// final class ConfigPlaceholder implements PlaceholderContract {
  ///   @override
  ///   String apply(String content) {
  ///     return content
  ///       .replaceAll('{{VERSION}}', '1.0.0')
  ///       .replaceAll('{{BOT_NAME}}', 'MyBot');
  ///   }
  /// }
  ///
  /// final builder = CommandDefinitionBuilder()
  ///   ..using(
  ///     File('assets/commands/info.yaml'),
  ///     placeholder: ConfigPlaceholder(),
  ///   );
  /// ```
  ///
  /// ### Complete workflow with class-based approach
  /// ```dart
  /// final class MyCommand implements CommandDefinition {
  ///   @override
  ///   CommandDefinitionBuilder build() {
  ///     return CommandDefinitionBuilder()
  ///       ..using(File('assets/commands/mycommand.yaml'))
  ///       ..setHandler('mycommand', handleCommand)
  ///       ..setHandler('mycommand.sub1', handleSub1)
  ///       ..setHandler('mycommand.sub2', handleSub2);
  ///   }
  ///   
  ///   void handleCommand(CommandContext ctx) {
  ///     // Handler implementation
  ///   }
  ///   
  ///   void handleSub1(CommandContext ctx) {
  ///     // Subcommand 1 implementation
  ///   }
  ///   
  ///   void handleSub2(CommandContext ctx) {
  ///     // Subcommand 2 implementation
  ///   }
  /// }
  /// 
  /// // Register the command
  /// client.register(MyCommand.new);
  /// ```
  ///
  /// ### Functional approach with client.commands.define
  /// ```dart
  /// final client = ClientBuilder().build();
  /// 
  /// client.commands.define((command) {
  ///   command
  ///     ..using(File('assets/commands/mycommand.yaml'))
  ///     ..setHandler('mycommand', (CommandContext ctx) {
  ///       // Handler implementation
  ///     })
  ///     ..setHandler('mycommand.sub1', (CommandContext ctx) {
  ///       // Subcommand 1 implementation
  ///     });
  /// });
  /// ```
  ///
  /// ### Environment-based configuration
  /// ```dart
  /// final env = Platform.environment['ENV'] ?? 'dev';
  /// final builder = CommandDefinitionBuilder()
  ///   ..using(File('assets/commands/$env/commands.yaml'));
  /// ```
  ///
  /// Parameters:
  /// - [file]: The configuration file to load (.yaml, .yml, or .json)
  /// - [placeholder]: Optional placeholder processor for dynamic values
  ///
  /// Throws:
  /// - [Exception] if the file format is not supported
  /// - [Exception] if the file structure is invalid
  /// - [FormatException] if the file contains invalid YAML/JSON
  ///
  /// See also:
  /// - [PlaceholderContract] for custom placeholder support
  /// - [setHandler] for attaching command handlers
  /// - [context] for advanced command configuration
  void using(File file, {PlaceholderContract? placeholder}) {
    final String stringContent = file.readAsStringSync();
    final content = switch (placeholder) {
      PlaceholderContract(:final apply) => apply(stringContent),
      _ => stringContent
    };

    final payload = switch (file.path) {
      final String path when path.contains('.json') => json.decode(content),
      final String path when path.contains('.yaml') =>
        (loadYaml(content) as YamlMap).toMap(),
      final String path when path.contains('.yml') =>
        (loadYaml(content) as YamlMap).toMap(),
      _ => throw Exception('File type not supported')
    };

    _declareCommand(payload);
    _declareGroups(payload);
    _declareSubCommands(payload);
  }

  /// Processes and creates the top-level command from the configuration.
  ///
  /// This internal method extracts the main command definition from the `commands`
  /// section where the command key doesn't contain dots (indicating a top-level command).
  ///
  /// The command is configured with localized names, descriptions, and options,
  /// and is registered in the internal command mapper.
  ///
  /// Parameters:
  /// - [content]: The root configuration map
  ///
  /// Throws [Exception] if the command definition is malformed.
  void _declareCommand(Map<String, dynamic> content) {
    final Map<String, dynamic> commandList = content['commands'] ?? {};

    for (final element in commandList.entries) {
      if (!element.key.contains('.')) {
        final String defaultName =
            _extractDefaultValue(element.key, 'name', element.value);
        final String defaultDescription =
            _extractDefaultValue(element.key, 'description', element.value);

        final nameTranslations = _extractTranslations('name', element.value);
        final descriptionTranslations =
            _extractTranslations('description', element.value);

        command
          ..setName(defaultName,
              translation: Translation({'name': nameTranslations}))
          ..setDescription(defaultDescription,
              translation:
                  Translation({'description': descriptionTranslations}));

        command.options.addAll(_declareOptions(element));

        _commandMapper[element.key] = () => command;
      }
    }
  }

  /// Processes and creates command groups from the configuration.
  ///
  /// This internal method extracts group definitions from the `groups` section
  /// and creates [CommandGroupBuilder] instances with localized names and descriptions.
  ///
  /// Groups are used to organize subcommands into logical categories, creating
  /// command hierarchies like `/parent group subcommand`.
  ///
  /// Parameters:
  /// - [content]: The root configuration map
  ///
  /// Throws [Exception] if group definitions are malformed.
  void _declareGroups(Map<String, dynamic> content) {
    final Map<String, dynamic> groupList = content['groups'] ?? {};

    for (final element in groupList.entries) {
      final String defaultName =
          _extractDefaultValue(element.key, 'name', element.value);
      final String defaultDescription =
          _extractDefaultValue(element.key, 'description', element.value);

      final nameTranslations = _extractTranslations('name', element.value);
      final descriptionTranslations =
          _extractTranslations('description', element.value);

      command.createGroup((group) {
        return group
          ..setName(defaultName,
              translation: Translation({'name': nameTranslations}))
          ..setDescription(defaultDescription,
              translation: Translation({'name': descriptionTranslations}));
      });
    }
  }

  /// Processes and creates command options from a command configuration entry.
  ///
  /// This internal method extracts the `options` array from a command configuration
  /// and creates appropriate [CommandOption] instances based on their types.
  ///
  /// Supported option types:
  /// - Basic types: string, integer, double, boolean, user, channel, role, mention
  /// - Choice types: choice.string, choice.integer, choice.double
  ///
  /// Each option can have localized names and descriptions, and can be marked
  /// as required or optional.
  ///
  /// Parameters:
  /// - [element]: A map entry containing the command configuration with options
  ///
  /// Returns a list of [CommandOption] instances.
  ///
  /// Throws [Exception] if option definitions are malformed or have unsupported types.
  List<CommandOption> _declareOptions(MapEntry<String, dynamic> element) {
    final options =
        List<Map<String, dynamic>>.from(element.value['options'] ?? []);

    return options.fold([], (acc, Map<String, dynamic> element) {
      final String name = _extractDefaultValue('option', 'name', element);
      final String description =
          _extractDefaultValue('option', 'description', element);
      final bool required = element['required'] ?? false;

      final option = switch (element['type']) {
        final String value when value == 'string' => Option.string(
            name: name, description: description, required: required),
        final String value when value == 'integer' => Option.integer(
            name: name, description: description, required: required),
        final String value when value == 'double' => Option.double(
            name: name, description: description, required: required),
        final String value when value == 'string' => Option.boolean(
            name: name, description: description, required: required),
        final String value when value == 'user' =>
          Option.user(name: name, description: description, required: required),
        final String value when value == 'channel' => Option.channel(
            name: name, description: description, required: required),
        final String value when value == 'role' =>
          Option.role(name: name, description: description, required: required),
        final String value when value == 'mention' => Option.mentionable(
            name: name, description: description, required: required),
        final String value when value == 'choice.string' => ChoiceOption.string(
            name: name,
            description: description,
            required: required,
            choices: List.from(element['choices'] ?? [])
                .map((element) =>
                    Choice<String>(element['name'], element['value']))
                .toList()),
        final String value when value == 'choice.integer' =>
          ChoiceOption.integer(
              name: name,
              description: description,
              required: required,
              choices: List.from(element['choices'] ?? [])
                  .map((element) =>
                      Choice(element['name'], int.parse(element['value'])))
                  .toList()),
        final String value when value == 'choice.double' => ChoiceOption.double(
            name: name,
            description: description,
            required: required,
            choices: List.from(element['choices'] ?? [])
                .map((element) =>
                    Choice(element['name'], double.parse(element['value'])))
                .toList()),
        _ => throw Exception('Unknown option type')
      };

      return [...acc, option];
    });
  }

  /// Processes and creates subcommands from the configuration.
  ///
  /// This internal method extracts subcommand definitions from the `commands` section
  /// where command keys contain dots (e.g., `parent.subcommand` or `parent.group.subcommand`).
  ///
  /// Subcommands can either be:
  /// - Direct subcommands: Attached directly to the parent command
  /// - Grouped subcommands: Attached to a specific command group
  ///
  /// Each subcommand is registered in the internal command mapper for later
  /// handler attachment via [setHandler].
  ///
  /// Parameters:
  /// - [content]: The root configuration map
  ///
  /// Throws [Exception] if subcommand definitions are malformed.
  void _declareSubCommands(Map<String, dynamic> content) {
    final Map<String, dynamic> commandList = content['commands'] ?? {};

    for (final element in commandList.entries) {
      if (element.key.contains('.')) {
        final String defaultName =
            _extractDefaultValue(element.key, 'name', element.value);
        final String defaultDescription =
            _extractDefaultValue(element.key, 'description', element.value);

        final nameTranslations = _extractTranslations('name', element.value);
        final descriptionTranslations =
            _extractTranslations('description', element.value);

        if (element.value['group'] case final String group) {
          final currentGroup = command.groups
              .firstWhere((element) => element.name == group)
            ..addSubCommand((command) {
              command
                ..setName(defaultName,
                    translation: Translation({'name': nameTranslations}))
                ..setDescription(defaultDescription,
                    translation:
                        Translation({'description': descriptionTranslations}));

              command.options.addAll(_declareOptions(element));
            });

          final int currentGroupIndex = command.groups.indexOf(currentGroup);
          final int currentSubCommandIndex =
              currentGroup.commands.indexOf(currentGroup.commands.last);
          _commandMapper[element.key] = () => command
              .groups[currentGroupIndex].commands[currentSubCommandIndex];
        } else {
          command.addSubCommand((command) {
            command
              ..setName(defaultName,
                  translation: Translation({'name': nameTranslations}))
              ..setDescription(defaultDescription,
                  translation:
                      Translation({'description': descriptionTranslations}));

            command.options.addAll(_declareOptions(element));
          });
          final currentSubCommandIndex =
              command.subCommands.indexOf(command.subCommands.last);
          _commandMapper[element.key] =
              () => command.subCommands[currentSubCommandIndex];
        }
      }
    }
  }

  /// Extracts the default value from a localized field in the configuration.
  ///
  /// This internal method retrieves the `_default` value from a localized field,
  /// which is required for all name and description fields.
  ///
  /// Parameters:
  /// - [commandKey]: The command identifier for error messages
  /// - [key]: The field name to extract (e.g., 'name', 'description')
  /// - [payload]: The configuration map containing the field
  ///
  /// Returns the default value string.
  ///
  /// Throws [Exception] if the field or default value is missing.
  String _extractDefaultValue(
      String commandKey, String key, Map<String, dynamic> payload,) {
    final Map<String, dynamic>? elements = payload[key];
    if (elements == null) {
      throw Exception('Missing "$key" key under $commandKey');
    }

    if (elements[_defaultIdentifier] case final String value) {
      return value;
    }

    throw Exception(
        'Missing "$key.$_defaultIdentifier" key under $commandKey struct');
  }

  /// Extracts translation mappings from a localized field in the configuration.
  ///
  /// This internal method processes all language-specific translations (excluding
  /// the `_default` entry) and converts them into a [Lang]-keyed map.
  ///
  /// Parameters:
  /// - [key]: The field name to extract translations from
  /// - [payload]: The configuration map containing localized values
  ///
  /// Returns a map of [Lang] enum values to translated strings.
  ///
  /// Throws [Exception] if the field is missing or contains invalid language codes.
  Map<Lang, String> _extractTranslations(
      String key, Map<String, dynamic> payload) {
    final Map<String, dynamic>? elements = payload[key];
    if (elements == null) {
      throw Exception('Missing "$key" key');
    }

    return elements.entries
        .whereNot((element) => element.key == _defaultIdentifier)
        .fold({}, (acc, element) {
      final lang = Lang.values.firstWhere((lang) => lang.uid == element.key);
      return {...acc, lang: element.value};
    });
  }
}
