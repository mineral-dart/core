import 'package:mineral/api/common/commands/command_option.dart';
import 'package:mineral/api/common/commands/command_type.dart';

final class SubCommandBuilder {
  String? name;
  String? description;
  final List<CommandOption> options = [];
  Function? handle;

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

  SubCommandBuilder setHandle(Function fn) {
    final firstArg = fn.toString().split('(')[1].split(')')[0].split(' ')[0];

    if (!firstArg.contains('CommandContext')) {
      throw Exception('The first argument of the handler function must be CommandContext');
    }

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
}
