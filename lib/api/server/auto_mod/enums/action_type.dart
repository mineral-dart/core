import 'package:mineral/api/common/types/enhanced_enum.dart';

enum ActionType implements EnhancedEnum<int> {
  blockMessage(1),
  sendAlertMessage(2),
  timeout(3);

  @override
  final int value;

  const ActionType(this.value);
}
