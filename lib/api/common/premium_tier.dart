import 'package:mineral/api/common/types/enhanced_enum.dart';

enum PremiumTier implements EnhancedEnum<int> {
  none(0),
  classic(1),
  game(2),
  basic(3);

  @override
  final int value;

  const PremiumTier(this.value);
}
