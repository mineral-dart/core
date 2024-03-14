import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';

final class PrivateGroupChannel extends Channel {
  final List<String> users;

  PrivateGroupChannel({
    required Snowflake id,
    required String name,
    required this.users,
  }): super(id, ChannelType.groupDm, name);
}
