import 'package:mineral/src/api/common/commands/builder/command_group_builder.dart';
import 'package:mineral/src/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/src/api/common/commands/command_context_type.dart';
import 'package:mineral/src/api/common/commands/command_option.dart';
import 'package:mineral/src/api/common/commands/command_type.dart';

final class CommandBuilder {
  String? _name;
  String? _description;
  CommandContextType context = CommandContextType.server;
  final List<CommandOption> _options = [];
  final List<SubCommandBuilder> _subCommands = [];
  final List<CommandGroupBuilder> _groups = [];
  Function? _handle;

  /// Set the name of the command. Must be unique.
  ///
  /// ```dart
  /// final command = CommandBuilder()
  ///  .setName('ping')
  ///  ```
  CommandBuilder setName(String name) {
    _name = name;
    return this;
  }

  /// Set the context of the command. Default is [CommandContextType.server].
  ///
  /// ```dart
  /// final command = CommandBuilder()
  /// .setContext(CommandContextType.user)
  /// ```
  CommandBuilder setContext(CommandContextType context) {
    this.context = context;
    return this;
  }

  /// Set the description of the command. This is optional.
  ///
  /// ```dart
  /// final command = CommandBuilder()
  /// .setDescription('Ping command')
  /// ```
  CommandBuilder setDescription(String description) {
    _description = description;
    return this;
  }

  /// Add an option to the command. This is a [CommandOption].
  ///
  /// ```dart
  /// final command = CommandBuilder()
  /// .addOption(CommandOptionBuilder()
  ///  .setName('name')
  ///  .setDescription('Name of the user')
  ///  ```
  CommandBuilder addOption<T extends CommandOption>(T option) {
    _options.add(option);
    return this;
  }

  /// Set the handler function for the command. This function will be called when the command is executed.
  ///
  /// ```dart
  /// final command = CommandBuilder()
  /// .handle((CommandContext ctx) async {
  ///     await ctx.reply('Pong!');
  /// })
  CommandBuilder handle(Function fn) {
    final firstArg = fn.toString().split('(')[1].split(')')[0].split(' ')[0];

    if (!firstArg.contains('CommandContext')) {
      throw Exception(
          'The first argument of the handler function must be CommandContext');
    }

    _handle = fn;
    return this;
  }

  /// Add a subcommand to the command. This can be a [SubCommandBuilder] or a [CommandGroupBuilder].
  ///
  /// ```dart
  /// final command = CommandBuilder()
  /// .addSubCommand((SubCommandBuilder builder) => builder
  ///     .setName('ping')
  ///     .setDescription('Ping command')
  /// ```
  CommandBuilder addSubCommand(
      SubCommandBuilder Function(SubCommandBuilder) command) {
    final builder = SubCommandBuilder();
    command(builder);
    _subCommands.add(builder);
    return this;
  }

  /// Create a group of subcommands. This can be a [CommandGroupBuilder].
  ///
  /// ```dart
  /// final command = CommandBuilder()
  /// .createGroup((CommandGroupBuilder builder) => builder
  ///    .setName('moderation')
  ///    .addSubCommand((SubCommandBuilder builder) => builder
  ///           .setName('kick')
  ///           .setDescription('Kick a user')
  ///           )
  ///         )
  ///  ```
  CommandBuilder createGroup(
      CommandGroupBuilder Function(CommandGroupBuilder) group) {
    final builder = CommandGroupBuilder();
    group(builder);
    _groups.add(builder);
    return this;
  }

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
            ('$_name.${group.name}.${subCommand.name}', subCommand.handle!));
      }
    }

    return handlers;
  }
}
