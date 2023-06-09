import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/helper.dart';
import 'package:mineral/src/internal/entities/commands/display.dart';
import 'package:mineral_contract/mineral_contract.dart';

class MineralCommand extends AbstractCommand implements MineralCommandContract {
  List<CommandOption> options;
  List<MineralSubcommand> subcommands;
  List<MineralCommandGroup> groups;

  final List<ClientPermission>? permissions;
  final bool everyone;
  final bool nsfw;

  MineralCommand(Display label, Display description, {
    CommandScope? scope,
    this.options = const [],
    this.subcommands = const [],
    this.groups = const [],
    this.permissions = const [],
    this.everyone = false,
    this.nsfw = false,
  }) : super(label, description, scope ?? CommandScope.guild);

  @override
  Map<String, dynamic> get serialize => {
    ...super.serialize,
    'type': CommandType.subcommand.type,
    'options': subcommands.isNotEmpty || groups.isNotEmpty
      ? [
      ...groups.map((group) => group.serialize).toList(),
      ...subcommands.map((command) => command.serialize).toList()
      ]
      : options.isNotEmpty
        ? [...options.map((option) => option.serialize)]
        : [],
    'default_member_permissions': !everyone
      ? permissions!.isNotEmpty
        ? Helper.toBitfield(permissions!.map((e) => e.value).toList()).toString()
        : null
      : 0,
    'nsfw': nsfw
  };
}