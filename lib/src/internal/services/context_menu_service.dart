import 'dart:async';

import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/context_menu_interaction.dart';
import 'package:mineral_contract/mineral_contract.dart';
import 'package:mineral_ioc/ioc.dart';

class ContextMenuService extends MineralService implements ContextMenuServiceContract {
  final Map<String, MineralContextMenu> _contextMenus = {};
  Map<String, MineralContextMenu> get contextMenus => _contextMenus;

  final StreamController<ContextMenuInteraction> controller = StreamController();

  ContextMenuService(List<ContextMenuServiceContract> mineralContextMenus): super(inject: true) {


    controller.stream.listen((event) async {
      final contextMenu = _contextMenus.findOrFail((element) => element.builder.label == event.label);
      await contextMenu.handle(event);
    });
  }

  @override
  void register(List<MineralContextMenuContract> contextMenus) {
    for (final contextMenu in List<MineralContextMenu>.from(contextMenus)) {
      _contextMenus.putIfAbsent(contextMenu.builder.label, () => contextMenu);
    }
  }

  List<MineralContextMenu> getFromGuild (Guild guild) {
    bool filter(MineralContextMenu element) => element.builder.scope.mode == Scope.guild.mode || element.builder.scope.mode == guild.id;

    return _contextMenus.where(filter).values.toList();
  }
}
