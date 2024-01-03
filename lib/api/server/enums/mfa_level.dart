import 'package:mineral/api/common/types/enhanced_enum.dart';

enum MfaLevel implements EnhancedEnum<int> {
  none(0),
  elevated(1);

  @override
  final int value;

  const MfaLevel(this.value);
}
