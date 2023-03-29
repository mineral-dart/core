import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';

class MessageBuilder {
  final String? content;
  final List<EmbedBuilder>? embeds;
  final ComponentBuilder? components;
  final List<MessageStickerItem>? stickers;

  MessageBuilder({ this.content, this.embeds, this.components, this.stickers });

  Object toJson () {
    final List<dynamic> _embeds = [];
    if (embeds != null) {
      for (final embed in embeds!) {
        _embeds.add(embed.toJson());
      }
    }

    final List<dynamic> _components = [];
    if (components?.rows != null) {
      for (final component in components!.rows) {
        _components.add(component.toJson());
      }
    }

    final List<dynamic> _stickers = [];
    if (stickers != null) {
      for (final sticker in stickers!) {
        _stickers.add(sticker.toJson());
      }
    }


    return {
      'content': content,
      'embeds': _embeds,
      'components': _components,
      'stickers': _stickers
    };
  }
}
