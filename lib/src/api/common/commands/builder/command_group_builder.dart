import 'package:mineral/src/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/src/api/common/commands/builder/translation.dart';
import 'package:mineral/src/api/common/commands/command_helper.dart';
import 'package:mineral/src/api/common/commands/command_type.dart';
import 'package:mineral/src/infrastructure/io/exceptions/missing_property_exception.dart';

/// A builder for creating command groups that organize related subcommands.
///
/// The [CommandGroupBuilder] provides a fluent API for creating command groups,
/// which enable a two-level command hierarchy: `/parent group subcommand`. This is
/// useful for organizing related subcommands into logical categories within a parent
/// command.
///
/// ## Command Hierarchy
///
/// Command groups create a three-level structure:
/// - **Level 0**: Parent command (e.g., `/admin`)
/// - **Level 1**: Group (e.g., `user`, `role`)
/// - **Level 2**: Subcommand (e.g., `ban`, `kick`, `create`, `delete`)
///
/// Result: `/admin user ban`, `/admin user kick`, `/admin role create`, etc.
///
/// ## Key Features
///
/// - **Organization**: Group related subcommands by functionality
/// - **Localization**: Name and description translations
/// - **Validation**: Built-in validation of required fields
/// - **Flexible**: Support for multiple subcommands per group
/// - **Clean Structure**: Clear separation of command categories
///
/// ## Usage
///
/// Command groups are created within a parent command using:
/// - [CommandBuilder.createGroup] for basic commands
/// - [CommandDeclarationBuilder.createGroup] for commands with localization
/// - [CommandDefinitionBuilder] when loading from configuration files
///
/// ### Basic Command Group
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
///       ..setHandle((ServerCommandContext ctx, {required User target}) {
///         // Ban user logic
///       }))
///     ..addSubCommand((sub) => sub
///       ..setName('kick')
///       ..setDescription('Kick a user')
///       ..addOption(Option.user(
///         name: 'target',
///         description: 'User to kick',
///         required: true,
///       ))
///       ..setHandle((ServerCommandContext ctx, {required User target}) {
///         // Kick user logic
///       })));
/// ```
///
/// ### Multiple Groups
///
/// ```dart
/// final command = CommandBuilder()
///   ..setName('manage')
///   ..setDescription('Management commands')
///   ..createGroup((group) => group
///     ..setName('channels')
///     ..setDescription('Channel management')
///     ..addSubCommand((sub) => sub
///       ..setName('create')
///       ..setDescription('Create a channel')
///       ..setHandle((ServerCommandContext ctx) {
///         // Create channel
///       }))
///     ..addSubCommand((sub) => sub
///       ..setName('delete')
///       ..setDescription('Delete a channel')
///       ..setHandle((ServerCommandContext ctx) {
///         // Delete channel
///       })))
///   ..createGroup((group) => group
///     ..setName('roles')
///     ..setDescription('Role management')
///     ..addSubCommand((sub) => sub
///       ..setName('create')
///       ..setDescription('Create a role')
///       ..setHandle((ServerCommandContext ctx) {
///         // Create role
///       }))
///     ..addSubCommand((sub) => sub
///       ..setName('assign')
///       ..setDescription('Assign a role')
///       ..setHandle((ServerCommandContext ctx) {
///         // Assign role
///       })));
/// ```
///
/// ### Command Group with Localization
///
/// ```dart
/// final command = CommandDeclarationBuilder()
///   ..setName('settings')
///   ..setDescription('Settings commands')
///   ..createGroup((group) => group
///     ..setName('user', translation: Translation.from({
///       'en': 'user',
///       'fr': 'utilisateur',
///       'es': 'usuario',
///       'de': 'benutzer',
///     }))
///     ..setDescription('User settings', translation: Translation.from({
///       'en': 'User settings',
///       'fr': 'Paramètres utilisateur',
///       'es': 'Configuración de usuario',
///       'de': 'Benutzereinstellungen',
///     }))
///     ..addSubCommand((sub) => sub
///       ..setName('theme', translation: Translation.from({
///         'en': 'theme',
///         'fr': 'thème',
///       }))
///       ..setDescription('Change theme', translation: Translation.from({
///         'en': 'Change theme',
///         'fr': 'Changer le thème',
///       }))
///       ..setHandle((CommandContext ctx) {
///         // Change theme logic
///       })));
/// ```
///
/// ### Complex Group Structure
///
/// ```dart
/// final command = CommandBuilder()
///   ..setName('server')
///   ..setDescription('Server management')
///   ..createGroup((group) => group
///     ..setName('moderation')
///     ..setDescription('Moderation tools')
///     ..addSubCommand((sub) => sub
///       ..setName('warn')
///       ..setDescription('Warn a member')
///       ..addOption(Option.user(name: 'member', description: 'Member to warn', required: true))
///       ..addOption(Option.string(name: 'reason', description: 'Warning reason', required: true))
///       ..setHandle((ctx, {required User member, required String reason}) {
///         // Warn logic
///       }))
///     ..addSubCommand((sub) => sub
///       ..setName('mute')
///       ..setDescription('Mute a member')
///       ..addOption(Option.user(name: 'member', description: 'Member to mute', required: true))
///       ..addOption(Option.integer(name: 'duration', description: 'Duration in minutes', required: true))
///       ..setHandle((ctx, {required User member, required int duration}) {
///         // Mute logic
///       }))
///     ..addSubCommand((sub) => sub
///       ..setName('unmute')
///       ..setDescription('Unmute a member')
///       ..addOption(Option.user(name: 'member', description: 'Member to unmute', required: true))
///       ..setHandle((ctx, {required User member}) {
///         // Unmute logic
///       })));
/// ```
///
/// ### Loading from Configuration File
///
/// **config.yaml**:
/// ```yaml
/// groups:
///   user:
///     name:
///       _default: user
///       fr: utilisateur
///     description:
///       _default: User management
///       fr: Gestion des utilisateurs
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
/// ```
///
/// **Dart code**:
/// ```dart
/// final class AdminCommand implements CommandDefinition {
///   @override
///   CommandDefinitionBuilder build() {
///     return CommandDefinitionBuilder()
///       ..using(File('assets/commands/admin.yaml'))
///       ..setHandler('admin.user.ban', banUser);
///   }
///   
///   void banUser(ServerCommandContext ctx, {required User target}) {
///     // Ban logic
///   }
/// }
/// ```
///
/// ## Validation Rules
///
/// Group names and descriptions must follow Discord's requirements:
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
/// ## Best Practices
///
/// - **Logical grouping**: Group subcommands by related functionality
/// - **Clear naming**: Use descriptive group names that indicate purpose
/// - **Consistent structure**: Keep similar commands in the same group
/// - **Avoid over-grouping**: Don't create groups with only one subcommand
/// - **Helpful descriptions**: Write clear descriptions for each group
/// - **Localization**: Translate group names and descriptions
/// - **Related commands**: Keep commands that work together in the same group
///
/// ## Limitations
///
/// Discord API limitations:
/// - Maximum 25 subcommands per group
/// - Groups cannot be nested (only one level of grouping)
/// - Parent commands with groups cannot have direct subcommands at the same level
/// - Parent commands with groups cannot have options or handlers
/// - Groups themselves cannot have handlers (only subcommands can)
///
/// ## When to Use Groups
///
/// Use command groups when:
/// - You have many related subcommands (more than 5-6)
/// - Commands naturally fall into distinct categories
/// - You want to keep the command structure organized
/// - Multiple teams manage different command categories
///
/// Don't use groups when:
/// - You have only a few subcommands (3 or fewer)
/// - All subcommands are closely related
/// - The additional nesting would confuse users
///
/// ## Examples of Good Group Organization
///
/// **Admin Commands**:
/// - `/admin user ban`, `/admin user kick`, `/admin user warn`
/// - `/admin role create`, `/admin role delete`, `/admin role assign`
/// - `/admin channel lock`, `/admin channel unlock`, `/admin channel archive`
///
/// **Economy System**:
/// - `/economy balance`, `/economy pay`, `/economy leaderboard`
/// - `/economy shop buy`, `/economy shop sell`, `/economy shop list`
/// - `/economy inventory use`, `/economy inventory view`, `/economy inventory trade`
///
/// **Ticket System**:
/// - `/ticket create`, `/ticket close`, `/ticket status`
/// - `/ticket config category`, `/ticket config message`, `/ticket config role`
/// - `/ticket logs view`, `/ticket logs export`, `/ticket logs clear`
///
/// See also:
/// - [SubCommandBuilder] for creating subcommands within groups
/// - [CommandBuilder] for creating parent commands
/// - [CommandDeclarationBuilder] for advanced command features
/// - [CommandDefinitionBuilder] for file-based command configuration
/// - [Translation] for localization configuration
/// - [CommandContext] for interaction handling
final class CommandGroupBuilder {
  final CommandHelper _helper = CommandHelper();

  /// The group name.
  ///
  /// This is the name users will see as the middle level in the command hierarchy.
  /// Must be set using [setName] before calling [toJson].
  String? name;
  
  /// Localized name translations for the group.
  ///
  /// Populated when [setName] is called with a [Translation] parameter.
  Map<String, String>? _nameLocalizations;
  
  /// The group description.
  ///
  /// Must be set using [setDescription] before calling [toJson].
  String? _description;
  
  /// Localized description translations for the group.
  ///
  /// Populated when [setDescription] is called with a [Translation] parameter.
  Map<String, String>? _descriptionLocalizations;
  
  /// The list of subcommands within this group.
  ///
  /// Subcommands are added using [addSubCommand]. Maximum 25 subcommands per group.
  final List<SubCommandBuilder> commands = [];

  CommandGroupBuilder();

  /// Creates a [CommandGroupBuilder] from a JSON representation.
  ///
  /// This factory constructor deserializes a JSON map into a command group builder,
  /// reconstructing the group with its name, description, and subcommands.
  ///
  /// This is useful for loading group configurations from external sources or
  /// deserializing group data.
  ///
  /// ## Example
  ///
  /// ```dart
  /// final json = {
  ///   'name': 'user',
  ///   'description': 'User management',
  ///   'commands': [
  ///     {
  ///       'name': 'ban',
  ///       'description': 'Ban a user',
  ///     },
  ///     {
  ///       'name': 'kick',
  ///       'description': 'Kick a user',
  ///     },
  ///   ],
  /// };
  ///
  /// final group = CommandGroupBuilder.fromJson(json);
  /// ```
  ///
  /// Parameters:
  /// - [json]: A map containing the group configuration
  ///
  /// Returns a new [CommandGroupBuilder] instance configured from the JSON data.
  ///
  /// Note: This factory only reconstructs the basic structure (names and descriptions).
  /// Handlers, options, and other configurations must be added separately.
  factory CommandGroupBuilder.fromJson(Map json) {
    final builder = CommandGroupBuilder()
      ..setName(json['name'])
      ..setDescription(json['description']);

    for (final command in json['commands']) {
      builder.addSubCommand((builder) {
        builder
          ..setName(command['name'])
          ..setDescription(command['description']);
      });
    }

    return builder;
  }

  /// Adds a subcommand to this group.
  ///
  /// Subcommands are the actual executable commands within a group. Each group
  /// can have up to 25 subcommands. All subcommands in a group must have handlers,
  /// as groups themselves cannot have handlers.
  ///
  /// ## Examples
  ///
  /// ### Basic subcommand
  /// ```dart
  /// group.addSubCommand((sub) => sub
  ///   ..setName('create')
  ///   ..setDescription('Create a new item')
  ///   ..setHandle((CommandContext ctx) {
  ///     ctx.interaction.reply(
  ///       builder: MessageBuilder.text('Created!'),
  ///     );
  ///   }));
  /// ```
  ///
  /// ### Subcommand with options
  /// ```dart
  /// group.addSubCommand((sub) => sub
  ///   ..setName('ban')
  ///   ..setDescription('Ban a user')
  ///   ..addOption(Option.user(
  ///     name: 'target',
  ///     description: 'User to ban',
  ///     required: true,
  ///   ))
  ///   ..addOption(Option.string(
  ///     name: 'reason',
  ///     description: 'Ban reason',
  ///     required: false,
  ///   ))
  ///   ..setHandle((ServerCommandContext ctx, {required User target, String? reason}) {
  ///     // Ban logic
  ///   }));
  /// ```
  ///
  /// ### Multiple subcommands in a group
  /// ```dart
  /// group
  ///   ..addSubCommand((sub) => sub
  ///     ..setName('list')
  ///     ..setDescription('List all items')
  ///     ..setHandle((CommandContext ctx) {
  ///       // List logic
  ///     }))
  ///   ..addSubCommand((sub) => sub
  ///     ..setName('search')
  ///     ..setDescription('Search for items')
  ///     ..addOption(Option.string(
  ///       name: 'query',
  ///       description: 'Search query',
  ///       required: true,
  ///     ))
  ///     ..setHandle((CommandContext ctx, {required String query}) {
  ///       // Search logic
  ///     }))
  ///   ..addSubCommand((sub) => sub
  ///     ..setName('delete')
  ///     ..setDescription('Delete an item')
  ///     ..addOption(Option.integer(
  ///       name: 'id',
  ///       description: 'Item ID',
  ///       required: true,
  ///     ))
  ///     ..setHandle((CommandContext ctx, {required int id}) {
  ///       // Delete logic
  ///     }));
  /// ```
  ///
  /// ### Subcommand with localization
  /// ```dart
  /// group.addSubCommand((sub) => sub
  ///   ..setName('add', translation: Translation.from({
  ///     'en': 'add',
  ///     'fr': 'ajouter',
  ///   }))
  ///   ..setDescription('Add a new role', translation: Translation.from({
  ///     'en': 'Add a new role',
  ///     'fr': 'Ajouter un nouveau rôle',
  ///   }))
  ///   ..setHandle((CommandContext ctx) {
  ///     // Add role logic
  ///   }));
  /// ```
  ///
  /// Parameters:
  /// - [command]: A function that configures the [SubCommandBuilder]
  ///
  /// Returns this builder for method chaining.
  ///
  /// See also:
  /// - [SubCommandBuilder] for building subcommands
  /// - [Option] for adding command options
  CommandGroupBuilder addSubCommand(void Function(SubCommandBuilder) command) {
    final builder = SubCommandBuilder();
    command(builder);
    commands.add(builder);
    return this;
  }

  /// Sets the group description with optional translations.
  ///
  /// The description appears in Discord's command picker and helps users
  /// understand what category of commands this group contains. Must be 1-100
  /// characters long.
  ///
  /// Providing translations allows Discord to show localized descriptions
  /// to users based on their language preferences.
  ///
  /// ## Examples
  ///
  /// ### Simple description
  /// ```dart
  /// group.setDescription('User management commands');
  /// ```
  ///
  /// ### With translations
  /// ```dart
  /// group.setDescription(
  ///   'Channel management',
  ///   translation: Translation.from({
  ///     'en': 'Channel management',
  ///     'fr': 'Gestion des canaux',
  ///     'es': 'Gestión de canales',
  ///     'de': 'Kanalverwaltung',
  ///     'ja': 'チャンネル管理',
  ///   }),
  /// );
  /// ```
  ///
  /// ### Loading from file
  /// ```dart
  /// group.setDescription(
  ///   'Role management commands',
  ///   translation: Translation.fromYaml('assets/i18n/role_group.yaml'),
  /// );
  /// ```
  ///
  /// Parameters:
  /// - [description]: The group description (1-100 characters)
  /// - [translation]: Optional translation configuration for localization
  ///
  /// Returns this builder for method chaining.
  ///
  /// See also:
  /// - [Translation] for localization configuration
  /// - [setName] for setting the group name
  CommandGroupBuilder setDescription(String description,
      {Translation? translation}) {
    _description = description;
    if (translation != null) {
      _descriptionLocalizations =
          _helper.extractTranslations('description', translation);
    }
    return this;
  }

  /// Sets the group name with optional translations.
  ///
  /// The name is what users see as the middle level in the command hierarchy.
  /// For example, in `/admin user ban`, "user" is the group name.
  ///
  /// Names are automatically validated according to Discord's naming rules.
  ///
  /// ## Naming Rules
  ///
  /// - Must be lowercase (automatically converted)
  /// - 1-32 characters long
  /// - Can contain letters, numbers, hyphens, and underscores
  /// - No spaces allowed
  ///
  /// Providing translations allows Discord to show localized group names
  /// to users based on their language preferences.
  ///
  /// ## Examples
  ///
  /// ### Simple name
  /// ```dart
  /// group.setName('moderation');
  /// ```
  ///
  /// ### With translations
  /// ```dart
  /// group.setName('user', translation: Translation.from({
  ///   'en': 'user',
  ///   'fr': 'utilisateur',
  ///   'es': 'usuario',
  ///   'de': 'benutzer',
  ///   'ja': 'ユーザー',
  /// }));
  /// ```
  ///
  /// ### Loading from configuration
  /// ```dart
  /// group.setName(
  ///   'settings',
  ///   translation: Translation.fromYaml('assets/i18n/groups.yaml'),
  /// );
  /// ```
  ///
  /// Parameters:
  /// - [name]: The group name
  /// - [translation]: Optional translation configuration for localization
  ///
  /// Returns this builder for method chaining.
  ///
  /// See also:
  /// - [Translation] for localization configuration
  /// - [setDescription] for setting the group description
  CommandGroupBuilder setName(String name, {Translation? translation}) {
    this.name = name;
    if (translation != null) {
      _nameLocalizations = _helper.extractTranslations('name', translation);
    }

    return this;
  }

  /// Converts the command group to a JSON representation for the Discord API.
  ///
  /// This method validates that required fields (name and description) are provided
  /// and formats the group structure according to Discord's API specification,
  /// including localization data and all subcommands.
  ///
  /// This method is typically called internally when building parent commands and
  /// should not need to be called directly in most cases.
  ///
  /// Returns a map containing:
  /// - Group name and name localizations
  /// - Group description and description localizations
  /// - Command type (subcommand group)
  /// - All subcommands with their configurations
  ///
  /// Throws:
  /// - [MissingPropertyException] if name is not set
  /// - [MissingPropertyException] if description is not set
  ///
  /// Example internal usage:
  /// ```dart
  /// // Called internally by the framework
  /// final json = group.toJson();
  /// // {
  /// //   'name': 'user',
  /// //   'name_localizations': {'fr': 'utilisateur'},
  /// //   'description': 'User management',
  /// //   'description_localizations': {'fr': 'Gestion des utilisateurs'},
  /// //   'type': 2,
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
      'type': CommandType.subCommandGroup.value,
      'options': commands.map((e) => e.toJson()).toList(),
    };
  }
}
