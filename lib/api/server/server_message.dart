import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/shared/utils.dart';

final class ServerMessage extends Message<ServerChannel> {
  final String userId;

  final Member author;

  ServerMessage({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required ServerChannel channel,
    required this.userId,
    required this.author,
  }): super(id, content, channel, createdAt, updatedAt);

  factory ServerMessage.fromJson({required Server server, required Map<String, dynamic> json}) {
    return ServerMessage(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['timestamp']),
      updatedAt: createOrNull(field: json['edited_timestamp'], fn: () => DateTime.parse(json['edited_timestamp'])),
      channel: server.channels.getOrFail(json['channel_id']),
      userId: json['author']['id'],
      author: server.members.getOrFail(json['author']['id'])
    );
  }
}
