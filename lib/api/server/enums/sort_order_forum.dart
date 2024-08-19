import 'package:mineral/api/common/types/enhanced_enum.dart';

enum SortOrderType implements EnhancedEnum<int> {
  lastedActivity(0),
  creationDate(1);

  @override
  final int value;

  const SortOrderType(this.value);
}
