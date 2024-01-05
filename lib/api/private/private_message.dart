import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/channels/guild_channel.dart';

final class PrivateMessage extends Message<GuildChannel> {
  final String userId;

  final User user;

  PrivateMessage({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    required GuildChannel channel,
    required this.userId,
    required this.user,
  }): super(id, content, channel, createdAt, updatedAt);
}
