import 'package:mineral/api/common/types/enhanced_enum.dart';

enum EventType implements EnhancedEnum<int> {
  messageSend(1);

  @override
  final int value;

  const EventType(this.value);
}
