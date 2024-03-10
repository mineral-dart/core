import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/domains/shared/helper.dart';

final class ServerMessage extends Message<ServerChannel> {
  final String userId;

  final Member author;

  ServerMessage({
    required Snowflake id,
    required String content,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required ServerChannel channel,
    required List<MessageEmbed> embeds,
    required this.userId,
    required this.author,
  }) : super(id, content, channel, embeds, createdAt, updatedAt);

  static Future<ServerMessage> fromJson(
      {required Server server, required Map<String, dynamic> json}) async {
    return ServerMessage(
        id: Snowflake(json['id']),
        content: json['content'],
        createdAt: DateTime.parse(json['timestamp']),
        updatedAt: Helper.createOrNull(
            field: json['edited_timestamp'], fn: () => DateTime.parse(json['edited_timestamp'])),
        channel: server.channels.getOrFail(json['channel_id']),
        embeds: List<MessageEmbed>.from(json['embeds'].map(MessageEmbed.fromJson)),
        userId: json['author']['id'],
        author: server.members.getOrFail(json['author']['id']));
  }
}
