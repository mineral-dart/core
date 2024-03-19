import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/domains/shared/helper.dart';

final class MessageProperties<T extends Channel> {
  final Snowflake id;
  final String content;
  final T channel;
  final List<MessageEmbed> embeds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MessageProperties({
    required this.id,
    required this.content,
    required this.channel,
    required this.embeds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageProperties.fromJson(T channel, Map<String, dynamic> json) {
    final embeds = List<MessageEmbed>.from(json['embeds']).map(MessageEmbed.fromJson).toList();

    return MessageProperties(
      id: Snowflake(json['id']),
      content: json['content'],
      channel: channel,
      embeds: embeds,
      createdAt: DateTime.parse(json['timestamp']),
      updatedAt: Helper.createOrNull(
          field: json['edited_timestamp'], fn: () => DateTime.parse(json['edited_timestamp'])),
    );
  }
}
