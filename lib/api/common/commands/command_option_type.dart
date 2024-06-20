import 'package:mineral/api/common/types/enhanced_enum.dart';

enum CommandOptionType implements EnhancedEnum<int> {
  string(3),
  integer(4),
  boolean(5),
  user(6),
  channel(7),
  role(8),
  mentionable(9),
  double(10),
  attachment(11);

  @override
  final int value;

  const CommandOptionType(this.value);
}
