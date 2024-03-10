import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/api/server/member.dart';

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
}
