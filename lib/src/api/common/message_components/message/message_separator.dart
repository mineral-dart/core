import 'package:mineral/api.dart';

enum SeparatorSize {
  small(1),
  large(2);

  final int value;
  const SeparatorSize(this.value);
}

final class MessageSeparator implements MessageComponent {
  ComponentType get type => ComponentType.separator;

  final bool _show;
  final SeparatorSize _spacing;

  MessageSeparator(this._show, this._spacing);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'divider': _show,
      'spacing': _spacing.value,
    };
  }
}
