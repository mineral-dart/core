import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/component_builder.dart';

class SelectMenuBuilder extends ComponentBuilder {
  final String _customId;
  final List<SelectMenuOption> _options = [];
  String? _placeholder;
  int _minValues = 1;
  int _maxValues = 25;
  bool _disabled = false;

  SelectMenuBuilder(this._customId) : super (type: ComponentType.selectMenu);

  void setPlaceholder (String value) => _placeholder = value;

  void setDisabled (bool value) => _disabled = value;

  void setMinValues (int value) => _minValues = value;

  void setMaxValues (int value) => _maxValues = value;

  void addOption<T> ({ required String label, String? description, required T value, EmojiBuilder? emoji }) {
    _options.add(SelectMenuOption(label: label, description: description, value: value, emoji: emoji));
  }

  RowBuilder toRow () => RowBuilder.fromComponents([this]);

  @override
  Object toJson () {
    return {
      'type': type.value,
      'custom_id': _customId,
      'options': _options.map((option) => option.toJson()).toList(),
      'placeholder': _placeholder,
      'min_values': _minValues,
      'max_values': _maxValues,
      'disabled': _disabled,
    };
  }
}

class EmojiOption {
  Snowflake? id;
  String name;

  EmojiOption({ this.id, required this.name });

  Object toJson () {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SelectMenuOption<T> {
  String label;
  String? description;
  T value;
  EmojiBuilder? emoji;

  SelectMenuOption({ required this.label, this.description, required this.value, this.emoji });

  toJson () {
    return {
      'label': label,
      'description': description,
      'value': value,
      'emoji': emoji?.emoji.toJson(),
    };
  }
}
