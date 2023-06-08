import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/exceptions/missing_method_exception.dart';
import 'package:mineral/src/internal/entities/commands/abstract_command.dart';
import 'package:mineral/src/internal/entities/commands/command_type.dart';

class MineralCommandGroup extends AbstractCommand {
  List<MineralSubcommand> subcommands;

  MineralCommandGroup(String label, String description, this.subcommands)
    : super(label, description, null);

  @override
  Map<String, dynamic> get serialize => {
    ...super.serialize,
    'type': CommandType.group.type,
    'options': subcommands.map((command) => command.serialize).toList()
  };
}