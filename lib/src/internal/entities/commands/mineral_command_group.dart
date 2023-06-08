import 'package:mineral/framework.dart';

class MineralCommandGroup extends AbstractCommand {
  List<MineralSubcommand> subcommands;

  MineralCommandGroup(String label, String description, this.subcommands, {
    Translate? labelTranslation,
    Translate? descriptionTranslation,
  }): super(label, description, labelTranslation, descriptionTranslation, null);

  @override
  Map<String, dynamic> get serialize => {
    ...super.serialize,
    'type': CommandType.group.type,
    'options': subcommands.map((command) => command.serialize).toList()
  };
}