import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/domains/shared/utils.dart';

final class PrivateMessage extends Message<PrivateChannel> {
  final String userId;

  final User user;

  PrivateMessage({
    required Snowflake id,
    required String content,
    required DateTime createdAt,
    required List<MessageEmbed> embeds,
    required DateTime? updatedAt,
    required PrivateChannel channel,
    required this.userId,
    required this.user,
  }): super(
    id,
    content,
    channel,
    embeds,
    createdAt,
    updatedAt,
  );

  factory PrivateMessage.fromJson({required Map<String, dynamic> json, required User user}) {
    final List<MessageEmbed> embeds = [];

    for (final embed in json['embeds']) {
      embeds.add(MessageEmbed.fromJson(embed));
    }

    return PrivateMessage(
        id: Snowflake(json['id']),
        content: json['content'],
        createdAt: DateTime.parse(json['timestamp']),
        updatedAt: createOrNull(field: json['edited_timestamp'], fn: () => DateTime.parse(json['edited_timestamp'])),
        channel: user.channel,
        userId: json['author']['id'],
        user: user,
        embeds: embeds,
    );
  }
}
