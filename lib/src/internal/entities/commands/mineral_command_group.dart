import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class MineralCommandGroup<T extends CommandInteraction> extends AbstractCommand {
  List<MineralSubcommand> subcommands;

  MineralCommandGroup({ required Display label, required Display description, required this.subcommands }): super(label, description, null);

  @override
  Map<String, dynamic> get serialize => {
    ...super.serialize,
    'type': CommandType.group.type,
    'options': subcommands.map((command) => command.serialize).toList()
  };
}