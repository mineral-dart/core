import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/common/channel.dart';
import 'package:mineral/src/api/common/embed/message_embed.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/domains/common/utils/helper.dart';

final class MessageProperties<T extends Channel> {
  final Snowflake id;
  final String content;
  final Snowflake channelId;
  final Snowflake? authorId;
  final Snowflake? serverId;
  final bool isAuthorBot;
  final List<MessageEmbed> embeds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MessageProperties({
    required this.id,
    required this.content,
    required this.channelId,
    required this.authorId,
    required this.serverId,
    required this.isAuthorBot,
    required this.embeds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageProperties.fromJson(Map<String, dynamic> json) {
    final embedSerializer = ioc.resolve<MarshallerContract>().serializers.embed;
    final embeds = List.from(json['embeds'])
        .map((element) => embedSerializer.serialize(element) as MessageEmbed)
        .toList();

    return MessageProperties(
      id: Snowflake.parse(json['id']),
      content: json['content'],
      channelId: Snowflake.parse(json['channel_id']),
      authorId: Snowflake.nullable(json['author_id']),
      serverId: Snowflake.nullable(json['server_id']),
      isAuthorBot: json['author_is_bot'] ?? false,
      embeds: embeds,
      createdAt: DateTime.parse(json['timestamp']),
      updatedAt: Helper.createOrNull(
          field: json['edited_timestamp'],
          fn: () => DateTime.parse(json['edited_timestamp'])),
    );
  }
}
