import 'package:mineral/framework.dart';

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