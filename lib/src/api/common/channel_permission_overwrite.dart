import 'package:mineral/api.dart';

enum ChannelPermissionOverwriteType implements EnhancedEnum<int> {
  role(0),
  member(1);

  @override
  final int value;

  const ChannelPermissionOverwriteType(this.value);
}

final class ChannelPermissionOverwrite {
  final String id;
  final ChannelPermissionOverwriteType type;
  final List<Permission> allow;
  final List<Permission> deny;

  ChannelPermissionOverwrite({
    required this.id,
    required this.type,
    this.allow = const [],
    this.deny = const [],
  });
}
