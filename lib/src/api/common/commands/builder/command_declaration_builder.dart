import 'package:mineral/src/api/common/commands/builder/command_group_builder.dart';
import 'package:mineral/src/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/src/api/common/commands/builder/translation.dart';
import 'package:mineral/src/api/common/commands/command_context_type.dart';
import 'package:mineral/src/api/common/commands/command_helper.dart';
import 'package:mineral/src/api/common/commands/command_option.dart';
import 'package:mineral/src/api/common/commands/command_type.dart';
import 'package:mineral/src/api/common/commands/sub_command_declaration.dart';
import 'package:mineral/src/domains/commands/command_builder.dart';
import 'package:mineral/src/infrastructure/io/exceptions/missing_method_exception.dart';
import 'package:mineral/src/infrastructure/io/exceptions/missing_property_exception.dart';

/// An advanced builder for constructing Discord slash commands with localization support.
///
/// The [CommandDeclarationBuilder] extends the basic [CommandBuilder] with additional
/// features for internationalization, including name and description translations for
/// multiple languages. It's the preferred builder when creating commands that need to
/// support users in different locales.
///
/// ## Key Features
///
/// - **Localization**: Translate command names and descriptions into multiple languages
/// - **Validation**: Automatic validation of command names and structure
/// - **Modular Subcommands**: Support for [SubCommandDeclaration] classes
/// - **Type Safety**: Compile-time checks for required fields
/// - **All CommandBuilder Features**: Inherits options, subcommands, and groups
///
/// ## Usage
///
/// Create a command declaration class implementing [CommandDeclaration]:
///
/// ```dart
/// final class GreetCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('greet', translation: Translation.from({
///         'en': 'greet',
///         'fr': 'saluer',
///         'es': 'saludar',
///       }))
///       ..setDescription('Greet a user', translation: Translation.from({
///         'en': 'Greet a user',
///         'fr': 'Saluer un utilisateur',
///         'es': 'Saludar a un usuario',
///       }))
///       ..addOption(Option.user(
///         name: 'target',
///         description: 'User to greet',
///         required: true,
///       ))
///       ..setHandle(handle);
///   }
///
///   void handle(CommandContext ctx, {required User target}) {
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Hello, ${target.username}!'),
///     );
///   }
/// }
/// ```
///
/// ## Examples
///
/// ### Simple localized command
///
/// ```dart
/// final class HelpCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('help')
///       ..setDescription('Show help information', translation: Translation.from({
///         'en': 'Show help information',
///         'fr': 'Afficher les informations d\'aide',
///         'de': 'Hilfeinformationen anzeigen',
///         'ja': 'ヘルプ情報を表示',
///       }))
///       ..setHandle((CommandContext ctx) {
///         ctx.interaction.reply(
///           builder: MessageBuilder.text('Help menu...'),
///         );
///       });
///   }
/// }
/// ```
///
/// ### Command with modular subcommands
///
/// ```dart
/// final class ManageCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('manage')
///       ..setDescription('Manage items')
///       // Using SubCommandDeclaration classes for modularity
///       ..registerSubCommand(AddSubCommand.new)
///       ..registerSubCommand(RemoveSubCommand.new)
///       ..registerSubCommand(ListSubCommand.new);
///   }
/// }
///
/// // Separate, reusable subcommand class
/// final class AddSubCommand implements SubCommandDeclaration {
///   @override
///   SubCommandBuilder build() {
///     return SubCommandBuilder()
///       ..setName('add')
///       ..setDescription('Add an item')
///       ..addOption(Option.string(
///         name: 'item',
///         description: 'Item to add',
///         required: true,
///       ))
///       ..setHandle(handle);
///   }
///
///   void handle(CommandContext ctx, {required String item}) {
///     // Add logic
///   }
/// }
/// ```
///
/// ### Command groups with context types
///
/// ```dart
/// final class AdminCommand implements CommandDeclaration {
///   @override
///   CommandDeclarationBuilder build() {
///     return CommandDeclarationBuilder()
///       ..setName('admin')
///       ..setDescription('Administrative commands')
///       ..setContext(CommandContextType.server) // Server-only
///       ..createGroup((group) => group
///         ..setName('user')
///         ..setDescription('User management')
///         ..addSubCommand((sub) => sub
///           ..setName('ban')
///           ..setDescription('Ban a user')
///           ..addOption(Option.user(
///             name: 'target',
///             description: 'User to ban',
///             required: true,
///           ))
///           ..setHandle((ServerCommandContext ctx, {required User target}) {
///             // Ban user
///           })));
///   }
/// }
/// ```
///
/// ## Translation Support
///
/// Discord supports localization for command names and descriptions in multiple languages:
///
/// - `da` - Danish
/// - `de` - German
/// - `en-GB` - English (UK)
/// - `en-US` - English (US)
/// - `es-ES` - Spanish
/// - `fr` - French
/// - `hr` - Croatian
/// - `it` - Italian
/// - `lt` - Lithuanian
/// - `hu` - Hungarian
/// - `nl` - Dutch
/// - `no` - Norwegian
/// - `pl` - Polish
/// - `pt-BR` - Portuguese (Brazilian)
/// - `ro` - Romanian
/// - `fi` - Finnish
/// - `sv-SE` - Swedish
/// - `vi` - Vietnamese
/// - `tr` - Turkish
/// - `cs` - Czech
/// - `el` - Greek
/// - `bg` - Bulgarian
/// - `ru` - Russian
/// - `uk` - Ukrainian
/// - `hi` - Hindi
/// - `th` - Thai
/// - `zh-CN` - Chinese (Simplified)
/// - `ja` - Japanese
/// - `zh-TW` - Chinese (Traditional)
/// - `ko` - Korean
///
/// ## Validation Rules
///
/// Command names are automatically validated and must:
/// - Be lowercase (automatically converted)
/// - Be 1-32 characters long
/// - Contain only letters, numbers, hyphens, and underscores
/// - Not contain spaces
///
/// Descriptions must:
/// - Be 1-100 characters long
/// - Be provided (required field)
///
/// ## vs CommandBuilder
///
/// Use [CommandDeclarationBuilder] when you need:
/// - Localization/translations
/// - Integration with [CommandDeclaration] interface
/// - Modular subcommands via [SubCommandDeclaration]
/// - Automatic name validation
///
/// Use basic [CommandBuilder] when you need:
/// - Simple, non-localized commands
/// - Programmatic command creation
/// - Dynamic command generation
///
/// ## Best Practices
///
/// - **Organize with classes**: Use [CommandDeclaration] for better organization
/// - **Modular subcommands**: Use [SubCommandDeclaration] for reusable subcommands
/// - **Provide translations**: Support international users with translations
/// - **Clear descriptions**: Write helpful descriptions in all languages
/// - **Consistent naming**: Follow a naming convention across commands
/// - **Context awareness**: Use appropriate context types
/// - **Error handling**: Handle errors gracefully with user feedback
///
/// See also:
/// - [CommandDeclaration] for command declaration interface
/// - [SubCommandDeclaration] for modular subcommands
/// - [Translation] for localization configuration
/// - [CommandBuilder] for basic command building
/// - [SubCommandBuilder] for building subcommands
/// - [CommandGroupBuilder] for organizing command groups
final class CommandDeclarationBuilder implements CommandBuilder {
  final CommandHelper _helper = CommandHelper();

  String? name;
  Map<String, String>? _nameLocalizations;
  String? _description;
  Map<String, String>? _descriptionLocalizations;
  CommandContextType context = CommandContextType.server;
  final List<CommandOption> options = [];
  final List<SubCommandBuilder> subCommands = [];
  final List<CommandGroupBuilder> groups = [];
  Function? _handle;

  /// Adds a command option (parameter).
  ///
  /// Options allow users to provide input when using the command. Discord supports
  /// various option types including strings, numbers, users, channels, and more.
  ///
  /// Commands can have up to 25 options. Options marked as `required: true` must
  /// come before optional options.
  ///
  /// Example:
  /// ```dart
  /// builder
  ///   ..addOption(Option.string(
  ///     name: 'message',
  ///     description: 'Message to send',
  ///     required: true,
  ///   ))
  ///   ..addOption(Option.user(
  ///     name: 'target',
  ///     description: 'User to mention',
  ///     required: false,
  ///   ));
  /// ```
  ///
  /// See also:
  /// - [Option] for available option types
  /// - [ChoiceOption] for options with predefined choices
  CommandDeclarationBuilder addOption<T extends CommandOption>(T option) {
    options.add(option);
    return this;
  }

  /// Adds an inline subcommand to the command.
  ///
  /// This method creates a subcommand using a builder function. For more modular
  /// and reusable subcommands, consider using [registerSubCommand] with
  /// [SubCommandDeclaration] classes instead.
  ///
  /// Commands can have either:
  /// - Options and a handler (simple command)
  /// - Subcommands (command with subcommands)
  /// - Command groups with subcommands (hierarchical structure)
  ///
  /// You cannot mix options and subcommands on the same command level.
  ///
  /// Example:
  /// ```dart
  /// builder
  ///   ..setName('todo')
  ///   ..setDescription('Manage tasks')
  ///   ..addSubCommand((sub) => sub
  ///     ..setName('add')
  ///     ..setDescription('Add a task')
  ///     ..addOption(Option.string(
  ///       name: 'task',
  ///       description: 'Task description',
  ///       required: true,
  ///     ))
  ///     ..setHandle((CommandContext ctx, {required String task}) {
  ///       // Add task logic
  ///     }))
  ///   ..addSubCommand((sub) => sub
  ///     ..setName('list')
  ///     ..setDescription('List all tasks')
  ///     ..setHandle((CommandContext ctx) {
  ///       // List tasks logic
  ///     }));
  /// ```
  ///
  /// See also:
  /// - [registerSubCommand] for modular subcommand classes
  /// - [SubCommandBuilder] for building subcommands
  /// - [createGroup] for organizing subcommands into groups
  CommandDeclarationBuilder addSubCommand(Function(SubCommandBuilder) command) {
    final builder = SubCommandBuilder();
    command(builder);

    subCommands.add(builder);
    return this;
  }

  /// Creates a command group to organize subcommands.
  ///
  /// Command groups provide a two-level hierarchy: `/parent group subcommand`.
  /// This is useful for organizing related subcommands into logical categories.
  ///
  /// For example, an `/admin` command with `user` and `role` groups:
  /// - `/admin user ban`
  /// - `/admin user kick`
  /// - `/admin role create`
  /// - `/admin role delete`
  ///
  /// Example:
  /// ```dart
  /// builder
  ///   ..setName('admin')
  ///   ..setDescription('Administration')
  ///   ..createGroup((group) => group
  ///     ..setName('user')
  ///     ..setDescription('User management')
  ///     ..addSubCommand((sub) => sub
  ///       ..setName('ban')
  ///       ..setDescription('Ban a user')
  ///       ..addOption(Option.user(
  ///         name: 'target',
  ///         description: 'User to ban',
  ///         required: true,
  ///       ))
  ///       ..setHandle((CommandContext ctx, {required User target}) {
  ///         // Ban logic
  ///       })))
  ///   ..createGroup((group) => group
  ///     ..setName('role')
  ///     ..setDescription('Role management')
  ///     ..addSubCommand((sub) => sub
  ///       ..setName('create')
  ///       ..setDescription('Create a role')
  ///       ..setHandle((CommandContext ctx) {
  ///         // Create role logic
  ///       })));
  /// ```
  ///
  /// See also:
  /// - [CommandGroupBuilder] for building command groups
  /// - [addSubCommand] for adding subcommands without groups
  CommandDeclarationBuilder createGroup(Function(CommandGroupBuilder) group) {
    final builder = CommandGroupBuilder();
    group(builder);

    groups.add(builder);
    return this;
  }

  /// Extracts all command handlers with their full paths.
  ///
  /// This method traverses the command structure and builds a list of tuples
  /// containing the full command path and its associated handler function.
  ///
  /// For example:
  /// - Simple command: `('commandname', handler)`
  /// - Subcommand: `('parent.subcommand', handler)`
  /// - Grouped subcommand: `('parent.group.subcommand', handler)`
  ///
  /// This method validates that all subcommands have handlers and throws
  /// [MissingMethodException] if any handler is missing.
  ///
  /// This method is used internally by the framework to map incoming interactions
  /// to their corresponding handlers. You typically don't need to call this directly.
  ///
  /// Parameters:
  /// - [commandName]: The parent command name for error messages
  ///
  /// Returns a list of tuples where each tuple contains:
  /// - The full command path as a string (e.g., "admin.user.ban")
  /// - The handler function for that command path
  ///
  /// Throws:
  /// - [MissingMethodException] if a subcommand is missing its handler
  List<(String, Function handler)> reduceHandlers(String commandName) {
    if (subCommands.isEmpty && groups.isEmpty) {
      return [('$name', _handle!)];
    }

    final List<(String, Function handler)> handlers = [];

    for (final subCommand in subCommands) {
      if (subCommand.handle case null) {
        throw MissingMethodException(
          'Command "$commandName.${subCommand.name}" has no handler',
        );
      }

      handlers.add(('$name.${subCommand.name}', subCommand.handle!));
    }

    for (final group in groups) {
      for (final subCommand in group.commands) {
        handlers.add(
          ('$name.${group.name}.${subCommand.name}', subCommand.handle!),
        );
      }
    }

    return handlers;
  }

  /// Registers a modular subcommand using a [SubCommandDeclaration] class.
  ///
  /// This method enables better code organization by allowing subcommands to be
  /// defined as separate, reusable classes. This is the recommended approach for
  /// complex commands with multiple subcommands.
  ///
  /// The [subCommandFactory] should be a constructor reference or factory function
  /// that returns a [SubCommandDeclaration] instance.
  ///
  /// ## Benefits
  ///
  /// - **Modularity**: Each subcommand is self-contained
  /// - **Reusability**: Share subcommands across multiple parent commands
  /// - **Maintainability**: Clear separation of concerns
  /// - **Simplified naming**: No need to create unique handler names for each subcommand in large commands
  /// - **Improved readability**: Main command class stays clean and focused, delegating complexity to subcommand classes
  ///
  /// ## Examples
  ///
  /// ### Basic usage
  /// ```dart
  /// // Define reusable subcommand
  /// final class AddSubCommand implements SubCommandDeclaration {
  ///   @override
  ///   SubCommandBuilder build() {
  ///     return SubCommandBuilder()
  ///       ..setName('add')
  ///       ..setDescription('Add an item')
  ///       ..addOption(Option.string(
  ///         name: 'item',
  ///         description: 'Item to add',
  ///         required: true,
  ///       ))
  ///       ..setHandle(handle);
  ///   }
  ///
  ///   void handle(CommandContext ctx, {required String item}) {
  ///     ctx.interaction.reply(
  ///       builder: MessageBuilder.text('Added: $item'),
  ///     );
  ///   }
  /// }
  ///
  /// // Register in parent command
  /// final class ManageCommand implements CommandDeclaration {
  ///   @override
  ///   CommandDeclarationBuilder build() {
  ///     return CommandDeclarationBuilder()
  ///       ..setName('manage')
  ///       ..setDescription('Manage items')
  ///       ..registerSubCommand(AddSubCommand.new);
  ///   }
  /// }
  /// ```
  ///
  /// ### Registering multiple subcommands
  /// ```dart
  /// builder
  ///   ..setName('todo')
  ///   ..setDescription('Manage tasks')
  ///   ..registerSubCommand(AddTaskSubCommand.new)
  ///   ..registerSubCommand(RemoveTaskSubCommand.new)
  ///   ..registerSubCommand(ListTasksSubCommand.new)
  ///   ..registerSubCommand(CompleteTaskSubCommand.new);
  /// ```
  ///
  /// ### Reusing subcommands across commands
  /// ```dart
  /// // Same subcommand used in multiple parents
  /// final class AdminCommand implements CommandDeclaration {
  ///   @override
  ///   CommandDeclarationBuilder build() {
  ///     return CommandDeclarationBuilder()
  ///       ..setName('admin')
  ///       ..setDescription('Admin commands')
  ///       ..registerSubCommand(ListSubCommand.new); // Reused
  ///   }
  /// }
  ///
  /// final class UserCommand implements CommandDeclaration {
  ///   @override
  ///   CommandDeclarationBuilder build() {
  ///     return CommandDeclarationBuilder()
  ///       ..setName('user')
  ///       ..setDescription('User commands')
  ///       ..registerSubCommand(ListSubCommand.new); // Reused
  ///   }
  /// }
  /// ```
  ///
  /// Throws [Exception] if the factory doesn't return a [SubCommandDeclaration] instance.
  ///
  /// See also:
  /// - [SubCommandDeclaration] for the subcommand interface
  /// - [addSubCommand] for inline subcommands
  /// - [SubCommandBuilder] for building subcommands
  CommandDeclarationBuilder registerSubCommand(Function subCommandFactory) {
    final instance = subCommandFactory();

    if (instance is! SubCommandDeclaration) {
      throw Exception('Factory must return a SubCommandDeclaration instance');
    }

    final builder = instance.build();
    subCommands.add(builder);
    return this;
  }

  /// Sets where the command can be used.
  ///
  /// Controls the availability of the command in different contexts:
  ///
  /// - [CommandContextType.server] - Only in server channels (default)
  ///   - Provides [ServerCommandContext] with guild information
  /// - [CommandContextType.all] - Available everywhere (servers and DMs)
  ///   - Provides [GlobalCommandContext] without guild-specific features
  ///
  /// Example:
  /// ```dart
  /// // Server-only command (default)
  /// builder.setContext(CommandContextType.server);
  ///
  /// // Global command (available in servers and DMs)
  /// builder.setContext(CommandContextType.global);
  /// ```
  CommandDeclarationBuilder setContext(CommandContextType context) {
    this.context = context;
    return this;
  }

  /// Sets the command description with optional translations.
  ///
  /// The description appears in Discord's command picker and helps users
  /// understand what the command does. Must be 1-100 characters long.
  ///
  /// Providing translations allows Discord to show localized descriptions
  /// to users based on their language preferences.
  ///
  /// ## Examples
  ///
  /// ### Simple description
  /// ```dart
  /// builder.setDescription('Displays user information');
  /// ```
  ///
  /// ### With translations
  /// ```dart
  /// builder.setDescription(
  ///   'Greet a user',
  ///   translation: Translation.from({
  ///     'en': 'Greet a user',
  ///     'fr': 'Saluer un utilisateur',
  ///     'es': 'Saludar a un usuario',
  ///     'de': 'Einen Benutzer grüßen',
  ///     'ja': 'ユーザーに挨拶する',
  ///   }),
  /// );
  /// ```
  ///
  /// ### Loading from file
  /// ```dart
  /// builder.setDescription(
  ///   'Show help',
  ///   translation: Translation.fromYaml('assets/i18n/help_command.yaml'),
  /// );
  /// ```
  ///
  /// See also:
  /// - [Translation] for localization configuration
  /// - [setName] for command name with translations
  CommandDeclarationBuilder setDescription(
    String description, {
    Translation? translation,
  }) {
    _description = description;
    if (translation != null) {
      _descriptionLocalizations = _helper.extractTranslations(
        'description',
        translation,
      );
    }
    return this;
  }

  /// Sets the command handler function.
  ///
  /// The handler is called when a user invokes the command. It must have
  /// [CommandContext] (or its subtypes [ServerCommandContext] or [GlobalCommandContext])
  /// as the first parameter, followed by named parameters that correspond to
  /// the command's options.
  ///
  /// ## Handler Signature
  ///
  /// ```dart
  /// void handler(
  ///   CommandContext ctx, {
  ///   required Type requiredParam,
  ///   Type? optionalParam,
  ///   Type paramWithDefault = defaultValue,
  /// }) {
  ///   // Implementation
  /// }
  /// ```
  ///
  /// ## Examples
  ///
  /// ### Simple handler
  /// ```dart
  /// builder.setHandle((CommandContext ctx) {
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text('Hello!'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Handler with parameters
  /// ```dart
  /// builder.setHandle((CommandContext ctx, {required String message}) {
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text('You said: $message'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Server-specific handler
  /// ```dart
  /// builder.setHandle((ServerCommandContext ctx, {required User target}) {
  ///   final guild = ctx.guild;
  ///   final member = guild.members.get(target.id);
  ///   // Server-specific logic
  /// });
  /// ```
  ///
  /// ### Async handler with defer
  /// ```dart
  /// builder.setHandle((CommandContext ctx) async {
  ///   // Defer for long operations
  ///   await ctx.interaction.defer();
  ///   
  ///   final result = await someAsyncOperation();
  ///   
  ///   await ctx.interaction.editReply(
  ///     builder: MessageBuilder.text('Result: $result'),
  ///   );
  /// });
  /// ```
  ///
  /// See also:
  /// - [CommandContext] for interaction handling
  /// - [ServerCommandContext] for server-specific commands
  /// - [GlobalCommandContext] for global commands
  CommandDeclarationBuilder setHandle(Function fn) {
    _handle = fn;
    return this;
  }

  /// Sets the command name with optional translations.
  ///
  /// The name is what users type to invoke the command (e.g., `/greet`, `/help`).
  /// Names are automatically converted to lowercase and validated according to
  /// Discord's naming rules.
  ///
  /// ## Naming Rules
  ///
  /// - Must be lowercase (automatically converted)
  /// - 1-32 characters long
  /// - Can contain letters, numbers, hyphens, and underscores
  /// - No spaces allowed
  ///
  /// Providing translations allows Discord to show localized command names
  /// to users based on their language preferences. Translations are also
  /// automatically validated.
  ///
  /// ## Examples
  ///
  /// ### Simple name
  /// ```dart
  /// builder.setName('user_info');
  /// ```
  ///
  /// ### With translations
  /// ```dart
  /// builder.setName(
  ///   'greet',
  ///   translation: Translation.from({
  ///     'en': 'greet',
  ///     'fr': 'saluer',
  ///     'es': 'saludar',
  ///     'de': 'grüßen',
  ///   }),
  /// );
  /// ```
  ///
  /// ### Loading from configuration
  /// ```dart
  /// builder.setName(
  ///   'help',
  ///   translation: Translation.fromYaml('assets/i18n/commands.yaml'),
  /// );
  /// ```
  ///
  /// ### Note on case conversion
  /// ```dart
  /// // These are equivalent:
  /// builder.setName('MyCommand'); // Converted to 'mycommand'
  /// builder.setName('mycommand');
  /// ```
  ///
  /// See also:
  /// - [Translation] for localization configuration
  /// - [setDescription] for command description with translations
  CommandDeclarationBuilder setName(String name, {Translation? translation}) {
    _helper.verifyName(name);

    this.name = name.toLowerCase();

    if (translation != null) {
      _nameLocalizations = _helper.extractTranslations('name', translation);

      for (final nameTranslation in _nameLocalizations!.values) {
        _helper.verifyName(nameTranslation);
      }
    }

    return this;
  }

  /// Converts the command to a JSON representation for the Discord API.
  ///
  /// This method validates that required fields (name and description) are provided
  /// and formats the command structure according to Discord's API specification,
  /// including localization data.
  ///
  /// This method is typically called internally when registering commands and
  /// should not need to be called directly in most cases.
  ///
  /// Returns a map containing:
  /// - Command name and name localizations
  /// - Command description and description localizations
  /// - Command type (if applicable)
  /// - All options, subcommands, and groups
  ///
  /// Throws:
  /// - [MissingPropertyException] if name is not set
  /// - [MissingPropertyException] if description is not set
  Map<String, dynamic> toJson() {
    if (name == null) {
      throw MissingPropertyException('Command name is required');
    }

    if (_description == null) {
      throw MissingPropertyException('Command description is required');
    }

    final List<Map<String, dynamic>> options = [
      for (final option in this.options) option.toJson(),
      for (final subCommand in subCommands) subCommand.toJson(),
      for (final group in groups) group.toJson(),
    ];

    return {
      'name': name,
      'name_localizations': _nameLocalizations,
      'description': _description,
      'description_localizations': _descriptionLocalizations,
      if (subCommands.isEmpty && groups.isEmpty)
        'type': CommandType.subCommand.value,
      'options': options,
    };
  }
}
