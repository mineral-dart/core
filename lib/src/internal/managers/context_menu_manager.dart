import 'dart:mirrors';

import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

class ContextMenuManager {
  final Map<String, MineralContextMenu> _contextMenus = {};
  Map<String, MineralContextMenu> get contextMenus => _contextMenus;

  void register (List<MineralContextMenu> mineralContextMenus) {
    for (final contextMenu in mineralContextMenus) {
      ContextMenu decorator = reflect(contextMenu).type.metadata.first.reflectee;
      contextMenu
        ..name = decorator.name
        ..description = decorator.description
        ..type = decorator.type
        ..everyone = decorator.everyone ?? false
        ..scope = decorator.scope;

      _contextMenus.putIfAbsent(contextMenu.name, () => contextMenu);
    }
  }

  List<MineralContextMenu> getFromGuild (Guild guild) {
    List<MineralContextMenu> commands = [];
    _contextMenus.forEach((name, command) {
      if (command.scope == guild.id || command.scope == 'GUILD') {
        commands.add(command);
      }
    });

    return commands;
  }
}
