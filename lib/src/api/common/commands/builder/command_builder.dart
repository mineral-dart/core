import 'package:mineral/src/api/common/commands/builder/command_group_builder.dart';
import 'package:mineral/src/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/src/api/common/commands/command_context_type.dart';
import 'package:mineral/src/api/common/commands/command_option.dart';
import 'package:mineral/src/api/common/commands/command_type.dart';

/// A builder for constructing Discord slash commands.
///
/// The [CommandBuilder] provides a fluent API for creating slash commands with
/// options, subcommands, and command groups. Commands can be registered globally
/// or within specific servers (guilds) to provide interactive experiences for
/// Discord users.
///
/// ## Command Types
///
/// - **Simple Commands**: Basic commands with optional parameters
/// - **Commands with Subcommands**: Commands that group related actions
/// - **Command Groups**: Hierarchical command organization with subcommand groups
///
/// ## Usage
///
/// Create a command using method chaining:
///
/// ```dart
/// final command = CommandBuilder()
///   ..setName('greet')
///   ..setDescription('Greet a user')
///   ..addOption(Option.user(
///     name: 'target',
///     description: 'User to greet',
///     required: true,
///   ))
///   ..handle((CommandContext ctx, {required User target}) {
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Hello, ${target.username}!'),
///     );
///   });
/// ```
///
/// ## Features
///
/// - **Options**: Add parameters like strings, numbers, users, channels, and roles
/// - **Subcommands**: Group related functionality under a parent command
/// - **Command Groups**: Organize subcommands into logical categories
/// - **Context Types**: Configure where commands are available (server/DM/both)
/// - **Type Safety**: Strongly-typed option handling with named parameters
///
/// ## Examples
///
/// ### Simple command with options
///
/// ```dart
/// final command = CommandBuilder()
///   ..setName('calculate')
///   ..setDescription('Perform a calculation')
///   ..addOption(Option.integer(
///     name: 'first',
///     description: 'First number',
///     required: true,
///   ))
///   ..addOption(Option.integer(
///     name: 'second',
///     description: 'Second number',
///     required: true,
///   ))
///   ..handle((CommandContext ctx, {required int first, required int second}) {
///     final result = first + second;
///     ctx.interaction.reply(
///       builder: MessageBuilder.text('Result: $result'),
///     );
///   });
/// ```
///
/// ### Command with subcommands
///
/// ```dart
/// final command = CommandBuilder()
///   ..setName('todo')
///   ..setDescription('Manage your todo list')
///   ..addSubCommand((sub) => sub
///     ..setName('add')
///     ..setDescription('Add a todo item')
///     ..addOption(Option.string(
///       name: 'task',
///       description: 'Task description',
///       required: true,
///     ))
///     ..setHandle((CommandContext ctx, {required String task}) {
///       // Add task logic
///       ctx.interaction.reply(
///         builder: MessageBuilder.text('Added: $task'),
///       );
///     }))
///   ..addSubCommand((sub) => sub
///     ..setName('list')
///     ..setDescription('List all todo items')
///     ..setHandle((CommandContext ctx) {
///       // List tasks logic
///       ctx.interaction.reply(
///         builder: MessageBuilder.text('Your tasks...'),
///       );
///     }));
/// ```
///
/// ### Command with groups
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
///       ..addOption(Option.user(name: 'target', description: 'User to ban', required: true))
///       ..setHandle((CommandContext ctx, {required User target}) {
///         // Ban logic
///       }))
///     ..addSubCommand((sub) => sub
///       ..setName('kick')
///       ..setDescription('Kick a user')
///       ..addOption(Option.user(name: 'target', description: 'User to kick', required: true))
///       ..setHandle((CommandContext ctx, {required User target}) {
///         // Kick logic
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
/// ### Setting command context
///
/// ```dart
/// // Server-only command (default)
/// final serverCommand = CommandBuilder()
///   ..setName('server_stats')
///   ..setDescription('Show server statistics')
///   ..setContext(CommandContextType.server)
///   ..handle((ServerCommandContext ctx) {
///     // Server-specific logic with guild access
///     final guild = ctx.server;
///     // ...
///   });
///
/// // Global command (available everywhere including DMs)
/// final globalCommand = CommandBuilder()
///   ..setName('help')
///   ..setDescription('Show help information')
///   ..setContext(CommandContextType.all)
///   ..handle((GlobalCommandContext ctx) {
///     // Global context - works in both servers and DMs
///     final user = ctx.user;
///     // ...
///   });
/// ```
///
/// ## Command Naming Rules
///
/// - Must be lowercase (automatically converted)
/// - Can contain letters, numbers, hyphens, and underscores
/// - Must be 1-32 characters long
/// - No spaces allowed
///
/// ## Option Types
///
/// Discord supports various option types:
///
/// - `Option.string()` - Text input
/// - `Option.integer()` - Whole numbers
/// - `Option.double()` - Decimal numbers
/// - `Option.boolean()` - True/false values
/// - `Option.user()` - User mention/selection
/// - `Option.channel()` - Channel selection
/// - `Option.role()` - Role selection
/// - `Option.mentionable()` - User or role selection
/// - `Option.attachment()` - File uploads
/// - `ChoiceOption.string()` - Predefined string choices
/// - `ChoiceOption.double()` - Predefined double choices
/// - `ChoiceOption.integer()` - Predefined number choices
///
/// ## Handler Signature
///
/// Command handlers must have [CommandContext] as the first parameter,
/// followed by named parameters matching the command options:
///
/// ```dart
/// void handler(
///   CommandContext ctx, {
///   required String requiredParam,
///   String? optionalParam,
///   int count = 0,
/// }) {
///   // Handler implementation
/// }
/// ```
///
/// ## Best Practices
///
/// - **Clear names**: Use descriptive command and option names
/// - **Helpful descriptions**: Write clear descriptions for users
/// - **Validate input**: Check option values in handlers
/// - **Error handling**: Handle errors gracefully with user feedback
/// - **Response timing**: Respond within 3 seconds or defer the interaction
/// - **Context awareness**: Use appropriate context types for command availability
/// - **Group logically**: Use subcommands and groups for related functionality
///
/// See also:
/// - [CommandDeclarationBuilder] for advanced features like translations
/// - [SubCommandBuilder] for building subcommands
/// - [CommandGroupBuilder] for organizing subcommands
/// - [CommandContext] for interaction handling
/// - [Option] for command option types
final class CommandBuilder {
  String? _name;
  String? _description;
  CommandContextType context = CommandContextType.server;
  final List<CommandOption> _options = [];
  final List<SubCommandBuilder> _subCommands = [];
  final List<CommandGroupBuilder> _groups = [];
  Function? _handle;

  /// Adds a command option (parameter).
  ///
  /// Options allow users to provide input when using the command. Discord supports
  /// various option types including strings, numbers, users, channels, and more.
  ///
  /// Commands can have up to 25 options. Options marked as `required: true` must
  /// come before optional options.
  ///
  /// ## Examples
  ///
  /// ### String option
  /// ```dart
  /// command.addOption(Option.string(
  ///   name: 'message',
  ///   description: 'Message to send',
  ///   required: true,
  /// ));
  /// ```
  ///
  /// ### Integer option with constraints
  /// ```dart
  /// command.addOption(Option.integer(
  ///   name: 'count',
  ///   description: 'Number of items',
  /// ));
  /// ```
  ///
  /// ### User mention option
  /// ```dart
  /// command.addOption(Option.user(
  ///   name: 'target',
  ///   description: 'User to mention',
  ///   required: true,
  /// ));
  /// ```
  ///
  /// ### Choice option with predefined values
  /// ```dart
  /// command.addOption(ChoiceOption.string(
  ///   name: 'color',
  ///   description: 'Choose a color',
  ///   required: true,
  ///   choices: [
  ///     Choice('Red', 'red'),
  ///     Choice('Blue', 'blue'),
  ///     Choice('Green', 'green'),
  ///   ],
  /// ));
  /// ```
  ///
  /// See also:
  /// - [Option] for available option types
  /// - [ChoiceOption] for options with predefined choices
  CommandBuilder addOption<T extends CommandOption>(T option) {
    _options.add(option);
    return this;
  }

  /// Adds a subcommand to the command.
  ///
  /// Subcommands allow you to group related functionality under a parent command.
  /// For example, a `/todo` command might have `add`, `remove`, and `list` subcommands,
  /// resulting in `/todo add`, `/todo remove`, and `/todo list`.
  ///
  /// Commands can have either:
  /// - Options and a handler (simple command)
  /// - Subcommands (command with subcommands)
  /// - Command groups with subcommands (hierarchical structure)
  ///
  /// You cannot mix options and subcommands on the same command level.
  ///
  /// ## Examples
  ///
  /// ### Basic subcommands
  /// ```dart
  /// command.addSubCommand((sub) => sub
  ///   ..setName('schedule')
  ///   ..setDescription('Schedule a task')
  ///   ..addOption(Option.string(
  ///     name: 'task',
  ///     description: 'Task description',
  ///     required: true,
  ///   ))
  ///   ..addOption(Option.string(
  ///     name: 'time',
  ///     description: 'When to schedule (e.g., 2h, tomorrow)',
  ///     required: true,
  ///   ))
  ///   ..setHandle((
  ///     CommandContext ctx, {
  ///     required String task,
  ///     required String time,
  ///   }) {
  ///     // Schedule task
  ///   }));
  /// ```
  ///
  /// ### Subcommand with multiple options
  /// ```dart
  /// command
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
  ///       // Add task
  ///     }))
  ///   ..addSubCommand((sub) => sub
  ///     ..setName('list')
  ///     ..setDescription('List all tasks')
  ///     ..setHandle((CommandContext ctx) {
  ///       // List tasks
  ///     }));
  /// ```
  ///
  /// See also:
  /// - [SubCommandBuilder] for building subcommands
  /// - [createGroup] for organizing subcommands into groups
  CommandBuilder addSubCommand(
    SubCommandBuilder Function(SubCommandBuilder) command,
  ) {
    final builder = SubCommandBuilder();
    command(builder);
    _subCommands.add(builder);
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
  /// Each group can contain multiple subcommands, and a command can have
  /// multiple groups. Commands with groups cannot have direct subcommands
  /// or options at the top level.
  ///
  /// ## Examples
  ///
  /// ### Basic command group
  /// ```dart
  /// command
  ///   ..setName('settings')
  ///   ..setDescription('Manage settings')
  ///   ..createGroup((group) => group
  ///     ..setName('user')
  ///     ..setDescription('User settings')
  ///     ..addSubCommand((sub) => sub
  ///       ..setName('theme')
  ///       ..setDescription('Change theme')
  ///       ..setHandle((CommandContext ctx) {
  ///         // Change theme
  ///       }))
  ///     ..addSubCommand((sub) => sub
  ///       ..setName('language')
  ///       ..setDescription('Change language')
  ///       ..setHandle((CommandContext ctx) {
  ///         // Change language
  ///       })));
  /// ```
  ///
  /// ### Multiple groups
  /// ```dart
  /// command
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
  ///         // Ban user
  ///       }))
  ///     ..addSubCommand((sub) => sub
  ///       ..setName('kick')
  ///       ..setDescription('Kick a user')
  ///       ..setHandle((CommandContext ctx) {
  ///         // Kick user
  ///       })))
  ///   ..createGroup((group) => group
  ///     ..setName('channel')
  ///     ..setDescription('Channel management')
  ///     ..addSubCommand((sub) => sub
  ///       ..setName('create')
  ///       ..setDescription('Create a channel')
  ///       ..setHandle((CommandContext ctx) {
  ///         // Create channel
  ///       }))
  ///     ..addSubCommand((sub) => sub
  ///       ..setName('delete')
  ///       ..setDescription('Delete a channel')
  ///       ..setHandle((CommandContext ctx) {
  ///         // Delete channel
  ///       })));
  /// ```
  ///
  /// See also:
  /// - [CommandGroupBuilder] for building command groups
  /// - [addSubCommand] for adding subcommands without groups
  CommandBuilder createGroup(
    CommandGroupBuilder Function(CommandGroupBuilder) group,
  ) {
    final builder = CommandGroupBuilder();
    group(builder);
    _groups.add(builder);
    return this;
  }

  /// Sets the command handler function.
  ///
  /// The handler is called when a user invokes the command. It must have
  /// [CommandContext] as the first parameter, followed by named parameters
  /// that correspond to the command's options.
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
  /// command.handle((CommandContext ctx) {
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text('Hello!'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Handler with required parameter
  /// ```dart
  /// command.handle((CommandContext ctx, {required String message}) {
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text('You said: $message'),
  ///   );
  /// });
  /// ```
  ///
  /// ### Handler with multiple parameters
  /// ```dart
  /// command.handle((
  ///   CommandContext ctx, {
  ///   required User target,
  ///   String? reason,
  ///   int duration = 60,
  /// }) {
  ///   final message = 'Action on ${target.username}';
  ///   if (reason != null) message += ': $reason';
  ///   message += ' (Duration: ${duration}s)';
  ///
  ///   ctx.interaction.reply(
  ///     builder: MessageBuilder.text(message),
  ///   );
  /// });
  /// ```
  ///
  /// ### Async handler
  /// ```dart
  /// command.handle((CommandContext ctx, {required String query}) async {
  ///   // Defer response for long operations
  ///   await ctx.interaction.defer();
  ///
  ///   final result = await database.query(query);
  ///
  ///   await ctx.interaction.editReply(
  ///     builder: MessageBuilder.text('Result: $result'),
  ///   );
  /// });
  /// ```
  ///
  /// Throws [Exception] if the first parameter is not [CommandContext].
  CommandBuilder handle(Function fn) {
    final firstArg = fn.toString().split('(')[1].split(')')[0].split(' ')[0];

    if (!firstArg.contains('CommandContext')) {
      throw Exception(
        'The first argument of the handler function must be CommandContext',
      );
    }

    _handle = fn;
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
  /// This method is used internally by the framework to map incoming interactions
  /// to their corresponding handlers. You typically don't need to call this directly.
  ///
  /// Returns a list of tuples where each tuple contains:
  /// - The full command path as a string (e.g., "admin.user.ban")
  /// - The handler function for that command path
  List<(String, Function handler)> reduceHandlers() {
    if (_subCommands.isEmpty && _groups.isEmpty) {
      return [('$_name', _handle!)];
    }

    final List<(String, Function handler)> handlers = [];

    for (final subCommand in _subCommands) {
      handlers.add(('$_name.${subCommand.name}', subCommand.handle!));
    }

    for (final group in _groups) {
      for (final subCommand in group.commands) {
        handlers.add(
          ('$_name.${group.name}.${subCommand.name}', subCommand.handle!),
        );
      }
    }

    return handlers;
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
  /// command.setContext(CommandContextType.server);
  ///
  /// // Global command (available in servers and DMs)
  /// command.setContext(CommandContextType.all);
  /// ```
  CommandBuilder setContext(CommandContextType context) {
    this.context = context;
    return this;
  }

  /// Sets the command description.
  ///
  /// The description appears in Discord's command picker and helps users
  /// understand what the command does. Must be 1-100 characters long.
  ///
  /// Example:
  /// ```dart
  /// command.setDescription('Displays information about a user');
  /// ```
  CommandBuilder setDescription(String description) {
    _description = description;
    return this;
  }

  /// Sets the command name.
  ///
  /// The name is what users type to invoke the command (e.g., `/greet`, `/help`).
  /// Command names must follow Discord's naming rules:
  ///
  /// - Must be lowercase (automatically converted)
  /// - 1-32 characters long
  /// - Can contain letters, numbers, hyphens, and underscores
  /// - No spaces allowed
  ///
  /// Example:
  /// ```dart
  /// command.setName('user_info');
  /// command.setName('ping');
  /// command.setName('get-data');
  /// ```
  CommandBuilder setName(String name) {
    _name = name;
    return this;
  }

  /// Converts the command to a JSON representation for the Discord API.
  ///
  /// This method is typically called internally when registering commands
  /// and should not need to be called directly in most cases.
  ///
  /// Returns a map containing the command structure formatted according to
  /// Discord's API specification.
  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> options = [
      for (final option in _options) option.toJson(),
      for (final subCommand in _subCommands) subCommand.toJson(),
      for (final group in _groups) group.toJson(),
    ];

    return {
      'name': _name,
      'description': _description,
      if (_subCommands.isEmpty && _groups.isEmpty)
        'type': CommandType.subCommand.value,
      'options': options,
    };
  }
}
