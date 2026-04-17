import 'package:mineral/src/api/common/types/enhanced_enum.dart';

enum CommandType implements EnhancedEnum<int> {
  subCommand(1),
  subCommandGroup(2),
  unknown(-1);

  @override
  final int value;

  const CommandType(this.value);
}
