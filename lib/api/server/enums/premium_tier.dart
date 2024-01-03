import 'package:mineral/api/common/types/enhanced_enum.dart';

enum PremiumTier implements EnhancedEnum<int> {
  none(0),
  one(1),
  two(2),
  three(3);

  @override
  final int value;

  const PremiumTier(this.value);
}
