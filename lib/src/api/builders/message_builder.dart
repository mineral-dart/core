import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';

/// [Message] builder
class MessageBuilder {
  /// Content of this as [String].
  final String? content;

  /// [EmbedBuilder] of this.
  final List<EmbedBuilder>? embeds;

  /// [ComponentBuilder] of this.
  final ComponentBuilder? components;

  /// [MessageStickerItem] of this.
  final List<MessageStickerItem>? stickers;

  MessageBuilder({ this.content, this.embeds, this.components, this.stickers });

  /// Serialize this to json.
  Object toJson () {
    final List<dynamic> _embeds = embeds != null
      ? List<dynamic>.from(embeds!.map((e) => e.toJson()))
      : [];

    final List<dynamic> _components = components?.rows != null
      ? List<dynamic>.from(components!.rows.map((e) => e.toJson()))
      : [];

    final List<dynamic> _stickers = stickers != null
      ? List<dynamic>.from(stickers!.map((e) => e.toJson()))
      : [];

    return {
      'content': content,
      'embeds': _embeds,
      'components': _components,
      'stickers': _stickers
    };
  }
}
