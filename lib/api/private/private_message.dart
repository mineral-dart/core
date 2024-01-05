import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/private/user.dart';

final class PrivateMessage extends Message<Channel> {
  final String userId;

  final User user;

  PrivateMessage({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    required Channel channel,
    required this.userId,
    required this.user,
  }): super(id, content, channel, createdAt, updatedAt);
}
