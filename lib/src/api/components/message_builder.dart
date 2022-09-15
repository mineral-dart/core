import 'package:mineral/api.dart';
import 'package:mineral/src/api/components/component.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';

class MessageBuilder {
  final String? content;
  final List<EmbedBuilder>? embeds;
  final List<Component>? components;
  final List<MessageStickerItem>? stickers;

  MessageBuilder({ this.content, this.embeds, this.components, this.stickers });

  Object toJson () => {
    'content': content,
    'embeds': embeds?.map((embed) => embed.toJson()),
    'components': components?.map((component) => component.toJson()),
    'stickers': stickers?.map((sticker) => sticker.toJson())
  };
}
