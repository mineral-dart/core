import 'package:mineral/api/common/types/enhanced_enum.dart';

enum DefaultMessageNotification implements EnhancedEnum<int> {
  allMessages(0),
  onlyMentions(1);

  @override
  final int value;

  const DefaultMessageNotification(this.value);
}
