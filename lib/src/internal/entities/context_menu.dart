import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral_contract/mineral_contract.dart';

class ContextMenuBuilder {
  final String _label;
  final CommandScope _scope;
  final ContextMenuType _type;
  final bool _everyone;

  ContextMenuBuilder(this._label, this._type, this._scope, this._everyone);

  String get label => _label;
  CommandScope get scope => _scope;
  ContextMenuType get type => _type;
  bool get everyone => _everyone;

  Object get toJson => {
    'name': _label,
    'type': _type.value
  };
}

abstract class MineralContextMenu<T> extends ContextMenuServiceContract<T> {
  late ContextMenuBuilder builder;

  MineralContextMenu(String label, ContextMenuType type, { CommandScope? scope, bool everyone = false }) {
    builder = ContextMenuBuilder(label, type, scope ?? CommandScope.guild, everyone);
  }

  Future<void> handle (T event);
}
