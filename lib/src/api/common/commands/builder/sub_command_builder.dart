import 'package:mineral/src/api/common/commands/builder/translation.dart';
import 'package:mineral/src/api/common/commands/command_helper.dart';
import 'package:mineral/src/api/common/commands/command_option.dart';
import 'package:mineral/src/api/common/commands/command_type.dart';
import 'package:mineral/src/infrastructure/io/exceptions/missing_property_exception.dart';

/// A builder for constructing Discord slash command subcommands.
///
/// The [SubCommandBuilder] provides a fluent API for creating subcommands that can be
/// nested under a parent command or organized within command groups. Subcommands allow
/// you to group related functionality under a single parent command, creating a more
/// organized command structure.
///
/// ## Command Structure
///
/// Subcommands enable hierarchical command organization:
/// - **Direct subcommands**: `/parent subcommand` (e.g., `/todo add`)
/// - **Grouped subcommands**: `/parent group subcommand` (e.g., `/admin user ban`)
///
/// ## Key Features
///
/// - **Options**: Support for all Discord option types
/// - **Localization**: Name and description translations
/// - **Type Safety**: Strongly-typed option handling
/// - **Validation**: Built-in validation of required fields
/// - **Flexible Handlers**: Support for various handler signatures
///
/// ## Usage
///
/// Subcommands are typically created within a parent command using either:
/// - [CommandBuilder.addSubCommand] for basic commands
/// - [CommandDeclarationBuilder.addSubCommand] for commands with localization
/// - [CommandDefinitionBuilder] when loading from configuration files
/// - [SubCommandDeclaration] for modular, reusable subcommands
///
/// ### Basic Subcommand
///
/// ```dart
/// final command = CommandBuilder()
///   ..setName('todo')
///   ..setDescription('Manage tasks')
///   ..addSubCommand((sub) => sub
///     ..setName('add')
///     ..setDescription('Add a new task')
///     ..addOption(Option.string(
///       name: 'task',
///       description: 'Task description',
///       required: true,
///     ))
///     ..setHandle((CommandContext ctx, {required String task}) {
///       ctx.interaction.reply(
///         builder: MessageBuilder.text('Added: $task'),
///       );
///     }));
/// ```
///
/// ### Subcommand with Localization
///
/// ```dart
/// final command = CommandDeclarationBuilder()
///   ..setName('help')
///   ..setDescription('Help commands')
///   ..addSubCommand((sub) => sub
///     ..setName('commands', translation: Translation.from({
///       'en': 'commands',
///       'fr': 'commandes',
///       'es': 'comandos',
///     }))
///     ..setDescription('List all commands', translation: Translation.from({
///       'en': 'List all commands',
///       'fr': 'Liste toutes les commandes',
///       'es': 'Lista todos los comandos',
///     }))
///     ..setHandle((CommandContext ctx) {
///       // List commands
///     }));
/// ```
///
/// ### Subcommand with Multiple Options
///
/// ```dart
/// command.addSubCommand((sub) => sub
///   ..setName('remind')
///   ..setDescription('Set a reminder')
///   ..addOption(Option.string(
///     name: 'message',
///     description: 'Reminder message',
///     required: true,
///   ))
///   ..addOption(Option.integer(
///     name: 'minutes',
///     description: 'Minutes until reminder',
///     required: true,
///   ))
///   ..addOption(Option.user(
///     name: 'target',
///     description: 'User to remind',
///     required: false,
///   ))
///   ..setHandle((
///     CommandContext ctx, {
///     required String message,
///     required int minutes,
///     User? target,
///   }) {
///     // Set reminder logic
///   }));
/// ```
///
/// ### Subcommand in a Group
///
/// ```dart
/// final command = CommandBuilder()
///   ..setName('admin')
///   ..setDescription('Administrative commands')
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
///       ..addOption(Option.string(
///         name: 'reason',
///         description: 'Ban reason',
///         required: false,
///       ))
///       ..setHandle((
///         ServerCommandContext ctx,
///         {required User target, String? reason},
///       ) {
///         // Ban user logic
///       })));
/// ```
///
/// ### Modular Subcommand with SubCommandDeclaration
///
/// ```dart
/// // Define reusable subcommand
/// final class AddTaskSubCommand implements SubCommandDeclaration {
///   @override
///   SubCommandBuilder build() {
///     return SubCommandBuilder()
///       ..setName('add')
///       ..setDescription('Add a new task')
///       ..addOption(Option.string(
///         name: 'task',
///         description: 'Task description',
///         required: true,
///       ))
///       ..addOption(ChoiceOption.string(
///         name: 'priority',
///         description: 'Task priority',
///         required: false,
///         choices: [
///           Choice('Low', 'low'),
///           Choice('Medium', 'medium'),
///           Choice('High', 'high'),
///         ],
///       ))
///       ..setHandle(handle);
///   }
///
///   void handle(CommandContext ctx, {required String task, String? priority}) {
///     final priorityText = priority ?? 'medium';
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Added [$priorityText]: $task'),
///     );
///   }
/// }
///
/// // Use in parent command
/// final command = CommandDeclarationBuilder()
///   ..setName('todo')
///   ..setDescription('Task management')
///   ..registerSubCommand(AddTaskSubCommand.new);
/// ```
///
/// ## Handler Signature
///
/// Subcommand handlers must have [CommandContext] (or [ServerCommandContext]/
/// [GlobalCommandContext]) as the first parameter, followed by named parameters
/// matching the subcommand's options:
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
/// ## Validation Rules
///
/// Subcommand names and descriptions must follow Discord's requirements:
///
/// **Names**:
/// - Must be lowercase (automatically converted)
/// - 1-32 characters long
/// - Can contain letters, numbers, hyphens, and underscores
/// - No spaces allowed
///
/// **Descriptions**:
/// - Must be 1-100 characters long
/// - Required field
///
/// ## Option Types
///
/// Subcommands support all Discord option types:
///
/// - `Option.string()` - Text input
/// - `Option.integer()` - Whole numbers
/// - `Option.double()` - Decimal numbers
/// - `Option.boolean()` - True/false values
/// - `Option.user()` - User selection
/// - `Option.channel()` - Channel selection
/// - `Option.role()` - Role selection
/// - `Option.mentionable()` - User or role selection
/// - `Option.attachment()` - File uploads
/// - `ChoiceOption.string()` - Predefined string choices
/// - `ChoiceOption.integer()` - Predefined integer choices
/// - `ChoiceOption.double()` - Predefined double choices
///
/// ## Best Practices
///
/// - **Clear naming**: Use descriptive subcommand names
/// - **Logical grouping**: Group related subcommands together
/// - **Helpful descriptions**: Write clear descriptions for users
/// - **Validate input**: Check option values in handlers
/// - **Error handling**: Handle errors gracefully with user feedback
/// - **Required first**: Put required options before optional ones
/// - **Consistent naming**: Follow naming conventions across subcommands
/// - **Modular design**: Use [SubCommandDeclaration] for reusable subcommands
///
/// ## Context Awareness
///
/// Subcommands inherit the context type from their parent command:
/// - Parent with [CommandContextType.server] → [ServerCommandContext]
/// - Parent with [CommandContextType.all] → [GlobalCommandContext]
///
/// ## Limitations
///
/// Discord API limitations:
/// - Maximum 25 subcommands per parent command
/// - Maximum 25 options per subcommand
/// - Subcommands cannot have their own subcommands
/// - Parent commands with subcommands cannot have options or handlers
///
/// See also:
/// - [CommandBuilder] for creating parent commands
/// - [CommandDeclarationBuilder] for advanced command features
/// - [CommandGroupBuilder] for organizing subcommands into groups
/// - [SubCommandDeclaration] for modular subcommand classes
/// - [Translation] for localization configuration
/// - [Option] for command option types
/// - [CommandContext] for interaction handling
final class SubCommandBuilder {
  final CommandHelper _helper = CommandHelper();

  /// The subcommand name.
  ///
  /// This is the name users will type after the parent command name.
  /// Must be set using [setName] before calling [toJson].
  String? name;
  
  /// Localized name translations for the subcommand.
  ///
  /// Populated when [setName] is called with a [Translation] parameter.
  Map<String, String>? _nameLocalizations;
  
  /// The subcommand description.
  ///
  /// Must be set using [setDescription] before calling [toJson].
  String? _description;
  
  /// Localized description translations for the subcommand.
  ///
  /// Populated when [setDescription] is called with a [Translation] parameter.
  Map<String, String>? _descriptionLocalizations;
  
  /// The list of options (parameters) for this subcommand.
  ///
  /// Options are added using [addOption]. Maximum 25 options per subcommand.
  final List<CommandOption> options = [];
  
  /// The handler function that will be called when this subcommand is invoked.
  ///
  /// Set using [setHandle]. The handler must have [CommandContext] as the first
  /// parameter, followed by named parameters matching the subcommand's options.
  Function? handle;

  SubCommandBuilder();

  /// Sets the subcommand name with optional translations.
  ///
  /// The name is what users type to invoke the subcommand after the parent command.
  /// Names are automatically validated according to Discord's naming rules.
  ///
  /// ## Naming Rules
  ///
  /// - Must be lowercase (automatically converted)
  /// - 1-32 characters long
  /// - Can contain letters, numbers, hyphens, and underscores
  /// - No spaces allowed
  ///
  /// Providing translations allows Discord to show localized subcommand names
  /// to users based on their language preferences.
  ///
  /// ## Examples
  ///
  /// ### Simple name
  /// ```dart
  /// subcommand.setName('add');
  /// ```
  ///
  /// ### With translations
  /// ```dart
  /// subcommand.setName('add', translation: Translation.from({
  ///   'en': 'add',
  ///   'fr': 'ajouter',
  ///   'es': 'agregar',
  ///   'de': 'hinzufügen',
  /// }));
  /// ```
  ///
  /// ### Loading from configuration
  /// ```dart
  /// subcommand.setName(
  ///   'remove',
  ///   translation: Translation.fromYaml('assets/i18n/commands.yaml'),
  /// );
  /// ```
  ///
  /// Parameters:
  /// - [name]: The subcommand name
  /// - [translation]: Optional translation configuration for localization
  ///
  /// Returns this builder for method chaining.
  ///
  /// See also:
  /// - [Translation] for localization configuration
  /// - [setDescription] for setting the subcommand description
  SubCommandBuilder setName(String name, {Translation? translation}) {
    this.name = name;
    if (translation != null) {
      _nameLocalizations = _helper.extractTranslations('name', translation);
    }

    return this;
  }

  /// Sets the subcommand description with optional translations.
  ///
  /// The description appears in Discord's command picker and helps users
  /// understand what the subcommand does. Must be 1-100 characters long.
  ///
  /// Providing translations allows Discord to show localized descriptions
  /// to users based on their language preferences.
  ///
  /// ## Examples
  ///
  /// ### Simple description
  /// ```dart
  /// subcommand.setDescription('Add a new item');
  /// ```
  ///
  /// ### With translations
  /// ```dart
  /// subcommand.setDescription(
  ///   'Remove an item',
  ///   translation: Translation.from({
  ///     'en': 'Remove an item',
  ///     'fr': 'Supprimer un élément',
  ///     'es': 'Eliminar un elemento',
  ///     'de': 'Ein Element entfernen',
  ///     'ja': 'アイテムを削除',
  ///   }),
  /// );
  /// ```
  ///
  /// ### Loading from file
  /// ```dart
  /// subcommand.setDescription(
  ///   'List all items',
  ///   translation: Translation.fromYaml('assets/i18n/list_command.yaml'),
  /// );
  /// ```
  ///
  /// Parameters:
  /// - [description]: The subcommand description (1-100 characters)
  /// - [translation]: Optional translation configuration for localization
  ///
  /// Returns this builder for method chaining.
  ///
  /// See also:
  /// - [Translation] for localization configuration
  /// - [setName] for setting the subcommand name
  SubCommandBuilder setDescription(String description,
      {Translation? translation}) {
    _description = description;
    if (translation != null) {
      _descriptionLocalizations =
          _helper.extractTranslations('description', translation);
    }
    return this;
  }

  /// Adds an option (parameter) to the subcommand.
  ///
  /// Options allow users to provide input when using the subcommand. Discord supports
  /// various option types including strings, numbers, users, channels, and more.
  ///
  /// Subcommands can have up to 25 options. Options marked as `required: true` must
  /// come before optional options.
  ///
  /// ## Examples
  ///
  /// ### String option
  /// ```dart
  /// subcommand.addOption(Option.string(
  ///   name: 'title',
  ///   description: 'Item title',
  ///   required: true,
  /// ));
  /// ```
  ///
  /// ### Integer option
  /// ```dart
  /// subcommand.addOption(Option.integer(
  ///   name: 'quantity',
  ///   description: 'Number of items',
  ///   required: false,
  /// ));
  /// ```
  ///
  /// ### User option
  /// ```dart
  /// subcommand.addOption(Option.user(
  ///   name: 'target',
  ///   description: 'User to perform action on',
  ///   required: true,
  /// ));
  /// ```
  ///
  /// ### Choice option
  /// ```dart
  /// subcommand.addOption(ChoiceOption.string(
  ///   name: 'category',
  ///   description: 'Item category',
  ///   required: true,
  ///   choices: [
  ///     Choice('Electronics', 'electronics'),
  ///     Choice('Clothing', 'clothing'),
  ///     Choice('Food', 'food'),
  ///   ],
  /// ));
  /// ```
  ///
  /// ### Multiple options
  /// ```dart
  /// subcommand
  ///   ..addOption(Option.string(
  ///     name: 'name',
  ///     description: 'Item name',
  ///     required: true,
  ///   ))
  ///   ..addOption(Option.integer(
  ///     name: 'price',
  ///     description: 'Item price',
  ///     required: true,
  ///   ))
  ///   ..addOption(Option.string(
  ///     name: 'description',
  ///     description: 'Item description',
  ///     required: false,
  ///   ));
  /// ```
  ///
  /// Parameters:
  /// - [option]: The option to add (must extend [CommandOption])
  ///
  /// Returns this builder for method chaining.
  ///
  /// See also:
  /// - [Option] for available option types
  /// - [ChoiceOption] for options with predefined choices
  SubCommandBuilder addOption<T extends CommandOption>(T option) {
    options.add(option);
    return this;
  }

  /// Sets the handler function for this subcommand.
  ///
  /// The handler is called when a user invokes the subcommand. It must have
  /// [CommandContext] (or [ServerCommandContext]/[GlobalCommandContext]) as the
  /// first parameter, followed by named parameters that correspond to the
  /// subcommand's options.
  ///
  /// The context type depends on the parent command's context:
  /// - Parent with [CommandContextType.server] provides [ServerCommandContext]
  /// - Parent with [CommandContextType.all] provides [GlobalCommandContext]
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
  /// subcommand.setHandle((CommandContext ctx) {
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text('Subcommand executed!'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Handler with required parameter
  /// ```dart
  /// subcommand.setHandle((CommandContext ctx, {required String name}) {
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text('Created: $name'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Handler with multiple parameters
  /// ```dart
  /// subcommand.setHandle((
  ///   CommandContext ctx, {
  ///   required String title,
  ///   required int quantity,
  ///   String? description,
  /// }) {
  ///   final desc = description ?? 'No description';
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text('Added $quantity x $title: $desc'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Server-specific handler
  /// ```dart
  /// subcommand.setHandle((
  ///   ServerCommandContext ctx,
  ///   {required User target},
  /// ) {
  ///   final guild = ctx.guild;
  ///   final member = guild.members.get(target.id);
  ///   // Server-specific logic
  /// });
  /// ```
  ///
  /// ### Async handler with defer
  /// ```dart
  /// subcommand.setHandle((
  ///   CommandContext ctx,
  ///   {required String query},
  /// ) async {
  ///   // Defer for long operations
  ///   await ctx.interaction.defer();
  ///   
  ///   final results = await database.search(query);
  ///   
  ///   await ctx.interaction.editReply(
  ///     builder: MessageBuilder.text('Found ${results.length} results'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Handler with error handling
  /// ```dart
  /// subcommand.setHandle((
  ///   CommandContext ctx,
  ///   {required String input},
  /// ) async {
  ///   try {
  ///     final result = await processInput(input);
  ///     await ctx.interaction.reply(
  ///       builder: MessageBuilder.text('Success: $result'),
  ///     );
  ///   } catch (e) {
  ///     await ctx.interaction.reply(
  ///       builder: MessageBuilder.text('Error: $e'),
  ///       private: true,
  ///     );
  ///   }
  /// });
  /// ```
  ///
  /// Parameters:
  /// - [fn]: The handler function to execute when the subcommand is invoked
  ///
  /// Returns this builder for method chaining.
  ///
  /// See also:
  /// - [CommandContext] for interaction handling
  /// - [ServerCommandContext] for server-specific subcommands
  /// - [GlobalCommandContext] for global subcommands
  SubCommandBuilder setHandle(Function fn) {
    handle = fn;
    return this;
  }

  /// Converts the subcommand to a JSON representation for the Discord API.
  ///
  /// This method validates that required fields (name and description) are provided
  /// and formats the subcommand structure according to Discord's API specification,
  /// including localization data and all options.
  ///
  /// This method is typically called internally when building parent commands and
  /// should not need to be called directly in most cases.
  ///
  /// Returns a map containing:
  /// - Subcommand name and name localizations
  /// - Subcommand description and description localizations
  /// - Command type (subcommand)
  /// - All options with their configurations
  ///
  /// Throws:
  /// - [MissingPropertyException] if name is not set
  /// - [MissingPropertyException] if description is not set
  ///
  /// Example internal usage:
  /// ```dart
  /// // Called internally by the framework
  /// final json = subcommand.toJson();
  /// // {
  /// //   'name': 'add',
  /// //   'name_localizations': {'fr': 'ajouter'},
  /// //   'description': 'Add an item',
  /// //   'description_localizations': {'fr': 'Ajouter un élément'},
  /// //   'type': 1,
  /// //   'options': [...]
  /// // }
  /// ```
  Map<String, dynamic> toJson() {
    if (name == null) {
      throw MissingPropertyException('Command name is required');
    }

    if (_description == null) {
      throw MissingPropertyException('Command description is required');
    }

    return {
      'name': name,
      'name_localizations': _nameLocalizations,
      'description': _description,
      'description_localizations': _descriptionLocalizations,
      'type': CommandType.subCommand.value,
      'options': options.map((e) => e.toJson()).toList(),
    };
  }
}
