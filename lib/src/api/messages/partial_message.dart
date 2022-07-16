import 'package:mineral/api.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/components/component.dart';
import 'package:mineral/src/api/messages/message_attachment.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';

class PartialMessage<T extends PartialChannel> {
  Snowflake id;
  String content;
  bool tts;
  List<MessageEmbed> embeds;
  bool allowMentions;
  PartialMessage? reference;
  List<Component> components;
  List<MessageStickerItem> stickers;
  dynamic payload;
  List<MessageAttachment> attachments;
  int? flags;
  Snowflake channelId;
  T channel;

  PartialMessage({
    required this.id,
    required this.content,
    required this.tts,
    required this.embeds,
    required this.allowMentions,
    required this.reference,
    required this.components,
    required this.stickers,
    required this.payload,
    required this.attachments,
    required this.flags,
    required this.channelId,
    required this.channel,
  });
}
