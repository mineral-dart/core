import 'package:mineral/src/api/common/types/enhanced_enum.dart';

enum PollLayout implements EnhancedEnum<int> {
  initial(1);

  @override
  final int value;
  const PollLayout(this.value);
}
