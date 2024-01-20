import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/domains/shared/utils.dart';

final class PrivateMessage extends Message<PrivateChannel> {
  final String userId;

  final User user;

  PrivateMessage({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required PrivateChannel channel,
    required this.userId,
    required this.user,
  }): super(id, content, channel, createdAt, updatedAt);

  factory PrivateMessage.fromJson({required Map<String, dynamic> json, required User user}) {
    return PrivateMessage(
        id: json['id'],
        content: json['content'],
        createdAt: DateTime.parse(json['timestamp']),
        updatedAt: createOrNull(field: json['edited_timestamp'], fn: () => DateTime.parse(json['edited_timestamp'])),
        channel: PrivateChannel.fromJson(json),
        userId: json['author']['id'],
        user: user
    );
  }
}
