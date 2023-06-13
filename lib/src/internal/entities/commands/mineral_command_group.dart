import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/entities/commands/display.dart';

import '../../../../core/api.dart';

class MineralCommandGroup<T extends CommandInteraction> extends AbstractCommand {
  List<MineralSubcommand> subcommands;
  final Display label;
  final Display description;

  MineralCommandGroup({ required this.label, required this.description, required this.subcommands }): super(label, description, null);

  @override
  Map<String, dynamic> get serialize => {
    ...super.serialize,
    'type': CommandType.group.type,
    'options': subcommands.map((command) => command.serialize).toList()
  };
}