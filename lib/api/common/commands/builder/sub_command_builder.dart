import 'dart:async';

import 'package:mineral/api/common/commands/command_option.dart';
import 'package:mineral/api/common/commands/command_type.dart';

final class SubCommandBuilder {
  String? _name;
  String? _description;
  final List<CommandOption> _options = [];
  FutureOr<void> Function()? _handle;

  SubCommandBuilder();

  SubCommandBuilder setName(String name) {
    _name = name;
    return this;
  }

  SubCommandBuilder setDescription(String description) {
    _description = description;
    return this;
  }

  SubCommandBuilder addOption<T extends CommandOption>(T option) {
    _options.add(option);
    return this;
  }

  SubCommandBuilder handle(FutureOr<void> Function() fn) {
    _handle = fn;
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'description': _description,
      'type': CommandType.subCommand.value,
      'options': _options.map((e) => e.toJson()).toList(),
    };
  }


  factory SubCommandBuilder.fromJson(Map json) {
    final builder = SubCommandBuilder()
      ..setName(json['name'])
      ..setDescription(json['description']);

    for (final option in json['options']) {
      builder.addOption(CommandOption.fromJson(option));
    }

    return builder;
  }
}
