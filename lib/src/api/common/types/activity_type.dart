import 'package:mineral/src/api/common/types/enhanced_enum.dart';

enum ActivityType implements EnhancedEnum<int> {
  playing(0),
  streaming(1),
  listening(2),
  watching(3),
  custom(4),
  competing(5),
  unknown(-1);

  @override
  final int value;

  const ActivityType(this.value);
}
