import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/managers/store_manager.dart';

class ContextMenu {
  final String name;
  final String description;
  final ContextMenuType type;
  final String scope;
  final bool? everyone;

  const ContextMenu ({ required this.name, this.description = '', required this.type, required this.scope, this.everyone });
}

abstract class MineralContextMenu {
  late final String name;
  late final String description;
  late final ContextMenuType type;
  late final String scope;
  late final bool everyone;

  late StoreManager stores;
  late MineralClient client;
  late Environment environment;

  Object toJson () {
    return {
      'name': name,
      'description': description,
      'type': type.value,
    };
  }
}
