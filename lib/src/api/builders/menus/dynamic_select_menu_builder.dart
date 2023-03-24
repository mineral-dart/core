import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/builders/menus/select_menu_builder.dart';

class DynamicSelectMenuBuilder extends SelectMenuBuilder {
  final List<SelectMenuOption> _options = [];

  DynamicSelectMenuBuilder(String customId) : super (customId, ComponentType.dynamicSelect);

  void addOption<T> ({ required String label, String? description, required T value, EmojiBuilder? emoji }) {
    _options.add(SelectMenuOption(label: label, description: description, value: value, emoji: emoji));
  }

  @override
  Map<String, dynamic>  toJson () => {
    ...super.toJson(),
    'options': _options.map((option) => option.toJson()).toList(),
  };
}

class EmojiOption {
  Snowflake? id;
  String name;

  EmojiOption({ this.id, required this.name });

  Map<String, dynamic> toJson () => {
    'id': id,
    'name': name,
  };
}

class SelectMenuOption<T> {
  String label;
  String? description;
  T value;
  EmojiBuilder? emoji;

  SelectMenuOption({ required this.label, this.description, required this.value, this.emoji });

  toJson () => {
    'label': label,
    'description': description,
    'value': value,
    'emoji': emoji?.emoji.toJson(),
  };
}
