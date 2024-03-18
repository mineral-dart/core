import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/enhanced_enum.dart';

enum ChannelPermissionOverwriteType implements EnhancedEnum<String> {
  role('role'),
  member('member');

  @override
  final String value;

  const ChannelPermissionOverwriteType(this.value);
}

final class ChannelPermissionOverwrite {
  final Snowflake id;
  final ChannelPermissionOverwriteType type;
  final String allow;
  final String deny;

  ChannelPermissionOverwrite({
    required this.id,
    required this.type,
    required this.allow,
    required this.deny,
  });
}
