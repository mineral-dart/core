import 'dart:async';

import 'package:mineral/api/common/commands/builder/command_builder.dart';
import 'package:mineral/api/common/commands/builder/command_group_builder.dart';
import 'package:mineral/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/api/common/commands/command_option.dart';

final class Command {
  String? name;
  String? description;
  final List<CommandOption> options;
  final List<SubCommandBuilder> subCommands;
  final List<CommandGroupBuilder> groups;
  FutureOr<void> Function()? handle;
  CommandBuilder builder;

  Command({
    required this.name,
    required this.description,
    required this.handle,
    required this.builder,
    this.options = const [],
    this.subCommands = const [],
    this.groups = const [],
  });
}