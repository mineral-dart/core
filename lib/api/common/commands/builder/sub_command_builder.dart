import 'dart:async';

import 'package:mineral/api/common/commands/command_option.dart';
import 'package:mineral/api/common/commands/command_type.dart';

final class SubCommandBuilder {
  String? name;
  String? description;
  final List<CommandOption> options = [];
  FutureOr<void> Function()? handle;

  SubCommandBuilder();

  SubCommandBuilder setName(String name) {
    this.name = name;
    return this;
  }

  SubCommandBuilder setDescription(String description) {
    this.description = description;
    return this;
  }

  SubCommandBuilder addOption<T extends CommandOption>(T option) {
    options.add(option);
    return this;
  }

  SubCommandBuilder setHandle(FutureOr<void> Function() fn) {
    handle = fn;
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'type': CommandType.subCommand.value,
      'options': options.map((e) => e.toJson()).toList(),
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
