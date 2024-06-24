import 'dart:async';

import 'package:mineral/api/common/commands/builder/command_group_builder.dart';
import 'package:mineral/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/api/common/commands/command_context_type.dart';
import 'package:mineral/api/common/commands/command_option.dart';
import 'package:mineral/api/common/commands/command_type.dart';
import 'package:mineral/infrastructure/interaction/command/command_context.dart';

final class CommandBuilder {
  String? _name;
  String? _description;
  CommandContextType context = CommandContextType.guild;
  final List<CommandOption> _options = [];
  final List<SubCommandBuilder> _subCommands = [];
  final List<CommandGroupBuilder> _groups = [];
  FutureOr<void> Function(CommandContext, List)? _handle;

  CommandBuilder setName(String name) {
    _name = name;
    return this;
  }

  CommandBuilder setContext(CommandContextType context) {
    this.context = context;
    return this;
  }

  CommandBuilder setDescription(String description) {
    _description = description;
    return this;
  }

  CommandBuilder addOption<T extends CommandOption>(T option) {
    _options.add(option);
    return this;
  }

  CommandBuilder handle(FutureOr<void> Function(CommandContext, List) fn) {
    _handle = fn;
    return this;
  }

  CommandBuilder addSubCommand(SubCommandBuilder Function(SubCommandBuilder) command) {
    final builder = SubCommandBuilder();
    command(builder);
    _subCommands.add(builder);
    return this;
  }

  CommandBuilder createGroup(CommandGroupBuilder Function(CommandGroupBuilder) group) {
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
      if (_subCommands.isEmpty && _groups.isEmpty) 'type': CommandType.subCommand.value,
      'options': options,
    };
  }

  List<(String, FutureOr<void> Function(CommandContext, List) handler)> reduceHandlers() {
    if (_subCommands.isEmpty && _groups.isEmpty) {
     return [('$_name', _handle!)];
    }

    final List<(String, FutureOr<void> Function(CommandContext, List) handler)> handlers = [];

    for (final subCommand in _subCommands) {
      handlers.add(('$_name.${subCommand.name}', subCommand.handle!));
    }

    for (final group in _groups) {
      for (final subCommand in group.commands) {
        handlers.add(('$_name.${group.name}.${subCommand.name}', subCommand.handle!));
      }
    }

    return handlers;
  }
}

