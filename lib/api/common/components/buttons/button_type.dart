import 'package:mineral/api/common/types/enhanced_enum.dart';

enum ButtonType implements EnhancedEnum<int> {
  primary(1),
  secondary(2),
  success(3),
  danger(4),
  link(5),
  premium(6);

  @override
  final int value;

  const ButtonType(this.value);
}
