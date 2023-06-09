import 'package:mineral/framework.dart';
import 'package:mineral/src/internal/entities/commands/display.dart';

class MineralCommandGroup extends AbstractCommand {
  List<MineralSubcommand> subcommands;

  MineralCommandGroup(Display label, Display description, this.subcommands): super(label, description, null);

  @override
  Map<String, dynamic> get serialize => {
    ...super.serialize,
    'type': CommandType.group.type,
    'options': subcommands.map((command) => command.serialize).toList()
  };
}