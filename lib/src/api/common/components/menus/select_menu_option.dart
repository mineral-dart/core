import 'package:mineral/src/api/common/partial_emoji.dart';

final class SelectMenuOption<T> {
  final String label;
  final String? description;
  final T value;
  final PartialEmoji? emoji;
  final bool? isDefault;

  SelectMenuOption(
      {required this.label,
      required this.value,
      this.description,
      this.emoji,
      this.isDefault = false});

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'value': value,
      'description': description,
      if (emoji != null)
        'emoji': {
          'name': emoji?.name,
          'id': emoji?.id,
          'animated': emoji?.animated,
        },
      'default': isDefault,
    };
  }
}
