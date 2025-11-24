import 'package:mineral/api.dart';

enum SeparatorSize {
  small(1),
  large(2);

  final int value;
  const SeparatorSize(this.value);
}

final class Separator implements MessageComponent {
  ComponentType get type => ComponentType.separator;

  final bool _isDividerVisible;
  final SeparatorSize _spacing;

  Separator(this._isDividerVisible, this._spacing);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'divider': _isDividerVisible,
      'spacing': _spacing.value,
    };
  }
}
