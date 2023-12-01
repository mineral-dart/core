import 'package:mineral/api/api/common/channel.dart';
import 'package:mineral/api/api/common/message.dart';
import 'package:mineral/api/api/private/user.dart';
import 'package:mineral/api/api/private/channels/private_channel.dart';

final class PrivateMessage implements Message {
  @override
  final String id;

  @override
  final String content;

  @override
  final String createdAt;

  @override
  final String updatedAt;

  @override
  final String channelId;

  @override
  PrivateChannel channel;

  final String userId;

  final User user;

  PrivateMessage({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.channelId,
    required this.channel,
    required this.userId,
    required this.user,
  });
}
