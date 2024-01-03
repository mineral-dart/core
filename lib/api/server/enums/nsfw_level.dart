import 'package:mineral/api/common/types/enhanced_enum.dart';

enum NsfwLevel implements EnhancedEnum<int> {
  none(0),
  explicit(1),
  safe(2),
  ageRestricted(3);

  @override
  final int value;

  const NsfwLevel(this.value);
}
