import 'package:mineral/api/common/types/enhanced_enum.dart';

enum ExplicitContentFilter implements EnhancedEnum<int> {
  disabled(0),
  membersWithoutRoles(1),
  allMembers(2);

  @override
  final int value;

  const ExplicitContentFilter(this.value);
}
