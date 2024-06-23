import 'package:mineral/api/common/commands/builder/sub_command_builder.dart';
import 'package:mineral/api/common/commands/command_type.dart';

final class CommandGroupBuilder {
  String? _name;
  String? _description;
  final List<SubCommandBuilder> _commands = [];

  CommandGroupBuilder();

  CommandGroupBuilder setName(String name) {
    _name = name;
    return this;
  }

  CommandGroupBuilder setDescription(String description) {
    _description = description;
    return this;
  }

  CommandGroupBuilder addSubCommand(void Function(SubCommandBuilder) command) {
    final builder = SubCommandBuilder();
    command(builder);
    _commands.add(builder);
    return this;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'description': _description,
      'type': CommandType.subCommandGroup.value,
      'options': _commands.map((e) => e.toJson()).toList(),
    };
  }

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
}
