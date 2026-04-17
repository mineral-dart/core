import 'package:mineral/src/api/common/color.dart';
import 'package:mineral/src/api/common/embed/message_embed_assets.dart';
import 'package:mineral/src/api/common/embed/message_embed_field.dart';
import 'package:mineral/src/api/common/embed/message_embed_provider.dart';
import 'package:mineral/src/api/common/embed/message_embed_type.dart';

final class MessageEmbed {
  final String? title;
  final String? description;
  final MessageEmbedType? type;
  final String? url;
  final DateTime? timestamp;
  final MessageEmbedAssets? assets;
  final MessageEmbedProvider? provider;
  final List<MessageEmbedField>? fields;
  final Color? color;

  MessageEmbed({
    this.title,
    this.description,
    this.url,
    this.timestamp,
    this.assets,
    this.fields,
    this.type,
    this.provider,
    this.color,
  });
}
