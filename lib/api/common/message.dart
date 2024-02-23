import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';

abstract class Message<T extends Channel> {
  final Snowflake id;
  final String content;
  final T channel;
  final List<MessageEmbed> embeds;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Message(
    this.id,
    this.content,
    this.channel,
    this.embeds,
    this.createdAt,
    this.updatedAt,
  );
}
