import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/infrastructure/data_store/data_store.dart';
import 'package:mineral/domains/shared/helper.dart';

final class MessageProperties<T extends Channel> {
  final Snowflake id;
  final String content;
  final Snowflake channelId;
  final List<MessageEmbed> embeds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MessageProperties({
    required this.id,
    required this.content,
    required this.channelId,
    required this.embeds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageProperties.fromJson(T channel, Map<String, dynamic> json) {
    final embedSerializer = DataStore.singleton().marshaller.serializers.embed;
    final embeds = List.from(json['embeds'])
        .map((element) => embedSerializer.serialize(element) as MessageEmbed)
        .toList();

    return MessageProperties(
      id: Snowflake(json['id']),
      content: json['content'],
      channelId: json['channel_id'],
      embeds: embeds,
      createdAt: DateTime.parse(json['timestamp']),
      updatedAt: Helper.createOrNull(
          field: json['edited_timestamp'], fn: () => DateTime.parse(json['edited_timestamp'])),
    );
  }
}
