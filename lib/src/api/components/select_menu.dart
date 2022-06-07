import 'package:mineral/api.dart';
import 'package:mineral/src/api/components/component.dart';

class SelectMenu extends Component {
  String customId;
  List<SelectMenuOption> options = [];

  SelectMenu({ required this.customId, required this.options }) : super (type: ComponentType.selectMenu);

  @override
  Object toJson () {
    return {
      'type': type.value,
      'custom_id': customId,
      'options': options.map((option) => option.toJson()).toList()
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
  String description;
  T value;
  EmojiOption? emoji;

  SelectMenuOption({ required this.label, required this.description, required this.value, this.emoji });

  toJson () {
    return {
      'label': label,
      'description': description,
      'value': value,
      'emoji': emoji?.toJson(),
    };
  }
}
