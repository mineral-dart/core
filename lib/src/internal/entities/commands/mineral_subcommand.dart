import 'package:mineral/core/api.dart';
import 'package:mineral/src/exceptions/missing_method_exception.dart';
import 'package:mineral/src/internal/entities/commands/abstract_command.dart';
import 'package:mineral/src/internal/entities/commands/command_option.dart';
import 'package:mineral/src/internal/entities/commands/command_scope.dart';
import 'package:mineral/src/internal/entities/commands/command_type.dart';

class MineralSubcommand<T extends CommandInteraction> extends AbstractCommand<T> {
  List<CommandOption> options;

  MineralSubcommand(String label, String description, { this.options = const [] })
    : super(label, description, null);

  @override
  Future<void> handle(T interaction) async {
    throw MissingMethodException('The handle method does not exist on your command ${interaction.identifier}');
  }

  @override
  Map<String, dynamic> get serialize => {
    ...super.serialize,
    'type': CommandType.subcommand.type,
    'options': [...options.map((option) => option.serialize)]
  };
}