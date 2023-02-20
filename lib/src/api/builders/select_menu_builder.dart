import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/component_builder.dart';

class SelectMenuBuilder extends ComponentBuilder {
  String customId;
  List<SelectMenuOption> options = [];
  String? placeholder;
  int? minValues = 1;
  int? maxValues = 25;
  bool? disabled = false;

  SelectMenuBuilder({ required this.customId, required this.options, this.placeholder, this.minValues, this.maxValues, this.disabled }) : super (type: ComponentType.selectMenu);

  RowBuilder toRow () => RowBuilder.fromComponents([this]);

  @override
  Object toJson () {
    return {
      'type': type.value,
      'custom_id': customId,
      'options': options.map((option) => option.toJson()).toList(),
      'placeholder': placeholder,
      'min_values': minValues,
      'max_values': maxValues,
      'disabled': disabled,
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
