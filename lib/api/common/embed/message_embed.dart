import 'package:mineral/api/common/embed/color.dart';
import 'package:mineral/api/common/embed/message_embed_author.dart';
import 'package:mineral/api/common/embed/message_embed_field.dart';
import 'package:mineral/api/common/embed/message_embed_footer.dart';
import 'package:mineral/api/common/embed/message_embed_image.dart';
import 'package:mineral/api/common/embed/message_embed_video.dart';

final class MessageEmbed {
  final String? title;
  final String? description;
  final Uri? url;
  final DateTime? timestamp;
  final Color? color;
  final MessageEmbedFooter? footer;
  final MessageEmbedImage? image;
  final MessageEmbedImage? thumbnail;
  final MessageEmbedVideo? video;
  final MessageEmbedAuthor? author;
  final List<MessageEmbedField> fields;

  MessageEmbed({
    this.title,
    this.description,
    this.url,
    this.timestamp,
    this.color,
    this.footer,
    this.image,
    this.thumbnail,
    this.video,
    this.author,
    this.fields = const []
  });

  Map<String, dynamic> get serializeAsJson => {
    'title': title,
    'description': description,
    'url': url?.toString(),
    'timestamp': timestamp?.toIso8601String(),
    'color': int.parse(color.toString().replaceAll('#', ''), radix: 16),
    'footer': footer?.serializeAsJson,
    'image': image?.serializeAsJson,
    'thumbnail': thumbnail?.serializeAsJson,
    'video': video?.serializeAsJson,
    'author': author?.serializeAsJson,
    'fields': fields.map((field) => field.serializeAsJson).toList()
  };
}