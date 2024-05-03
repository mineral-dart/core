import 'package:mineral/api/common/types/enhanced_enum.dart';

enum TriggerType implements EnhancedEnum<int> {
  keyword(1),
  spam(3),
  keywordPreset(4),
  mentionSpam(5);

  @override
  final int value;

  const TriggerType(this.value);
}
