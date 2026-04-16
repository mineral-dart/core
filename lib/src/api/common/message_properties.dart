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
  final bool authorIsBot;
  final List<MessageEmbed> embeds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MessageProperties({
    required this.id,
    required this.content,
    required this.channelId,
    required this.authorId,
    required this.serverId,
    required this.authorIsBot,
    required this.embeds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageProperties.fromJson(Map<String, dynamic> json) {
    final embedSerializer = ioc.resolve<MarshallerContract>().serializers.embed;
    final embeds = List.from(json['embeds'] as Iterable<dynamic>)
        .map((element) => embedSerializer.serialize(element as Map<String, dynamic>) as MessageEmbed)
        .toList();

    return MessageProperties(
      id: Snowflake.parse(json['id']),
      content: json['content'] as String,
      channelId: Snowflake.parse(json['channel_id']),
      authorId: Snowflake.nullable(json['author_id']),
      serverId: Snowflake.nullable(json['server_id']),
      authorIsBot: json['author_is_bot'] as bool? ?? false,
      embeds: embeds,
      createdAt: DateTime.parse(json['timestamp'] as String),
      updatedAt: Helper.createOrNull(
          field: json['edited_timestamp'],
          fn: () => DateTime.parse(json['edited_timestamp'] as String)),
    );
  }
}
