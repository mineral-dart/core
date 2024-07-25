import 'package:mineral/api/common/commands/builder/command_group_builder.dart';
import 'package:mineral/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/api/common/commands/builder/translation.dart';
import 'package:mineral/api/common/commands/command_context_type.dart';
import 'package:mineral/api/common/commands/command_helper.dart';
import 'package:mineral/api/common/commands/command_option.dart';
import 'package:mineral/api/common/commands/command_type.dart';

final class CommandBuilder {
  final CommandHelper _helper = CommandHelper();

  String? _name;
  Map<String, String>? _nameLocalizations;
  String? _description;
  Map<String, String>? _descriptionLocalizations;
  CommandContextType context = CommandContextType.guild;
  final List<CommandOption> options = [];
  final List<SubCommandBuilder> subCommands = [];
  final List<CommandGroupBuilder> groups = [];
  Function? _handle;

  CommandBuilder setName(String name, {Translation? translation}) {
    _name = name;
    if (translation != null) {
      _nameLocalizations = _helper.extractTranslations('name', translation);
    }

    return this;
  }

  CommandBuilder setContext(CommandContextType context) {
    this.context = context;
    return this;
  }

  CommandBuilder setDescription(String description, {Translation? translation}) {
    _description = description;
    if (translation != null) {
      _descriptionLocalizations = _helper.extractTranslations('description', translation);
    }
    return this;
  }

  CommandBuilder addOption<T extends CommandOption>(T option) {
    options.add(option);
    return this;
  }

  CommandBuilder setHandle(Function fn) {
    final firstArg = fn.toString().split('(')[1].split(')')[0].split(' ')[0];

    if (!firstArg.contains('CommandContext')) {
      throw Exception('The first argument of the handler function must be CommandContext');
    }

    _handle = fn;
    return this;
  }

  CommandBuilder addSubCommand(Function(SubCommandBuilder) command) {
    final builder = SubCommandBuilder();
    command(builder);

    subCommands.add(builder);
    return this;
  }

  CommandBuilder createGroup(CommandGroupBuilder Function(CommandGroupBuilder) group) {
    final builder = CommandGroupBuilder();
    group(builder);

    groups.add(builder);
    return this;
  }

  Map<String, dynamic> toJson() {
    final List<Map<String, dynamic>> options = [
      for (final option in this.options) option.toJson(),
      for (final subCommand in subCommands) subCommand.toJson(),
      for (final group in groups) group.toJson(),
    ];

    return {
      'name': _name,
      'name_localizations': _nameLocalizations,
      'description': _description,
      'description_localizations': _descriptionLocalizations,
      if (subCommands.isEmpty && groups.isEmpty) 'type': CommandType.subCommand.value,
      'options': options,
    };
  }

  List<(String, Function handler)> reduceHandlers() {
    if (subCommands.isEmpty && groups.isEmpty) {
      return [('$_name', _handle!)];
    }

    final List<(String, Function handler)> handlers = [];

    for (final subCommand in subCommands) {
      handlers.add(('$_name.${subCommand.name}', subCommand.handle!));
    }

    for (final group in groups) {
      for (final subCommand in group.commands) {
        handlers.add(('$_name.${group.name}.${subCommand.name}', subCommand.handle!));
      }
    }

    return handlers;
  }
}

