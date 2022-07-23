import 'package:mineral/core.dart';

class Module {
  final String identifier;
  final String label;
  final String? description;

  const Module({ required this.identifier, required this.label, this.description });
}

abstract class MineralModule {
  late final String identifier;
  late final String label;
  late final String? description;

  abstract List<MineralEvent> events;
  abstract List<MineralCommand> commands;
  abstract List<MineralStore> stores;
  abstract List<MineralContextMenu> contextMenu;

  Future<void> init () async {}
}
