import 'package:mineral/api/common/embed/message_embed_author.dart';
import 'package:mineral/api/common/embed/message_embed_footer.dart';
import 'package:mineral/api/common/embed/message_embed_image.dart';
import 'package:mineral/domains/shared/utils.dart';

final class MessageEmbedAssets {
  final MessageEmbedImage? image;
  final MessageEmbedImage? thumbnail;
  final MessageEmbedImage? video;
  final MessageEmbedFooter? footer;
  final MessageEmbedAuthor? author;
  final int color;

  const MessageEmbedAssets({
    required this.image,
    required this.thumbnail,
    required this.video,
    required this.footer,
    required this.author,
    required this.color,
  });

  factory MessageEmbedAssets.fromJson(Map<String, dynamic> json) {
    return MessageEmbedAssets(
      image:
          createOrNull(field: json['image'], fn: () => MessageEmbedImage.fromJson(json['image'])),
      thumbnail: createOrNull(
          field: json['thumbnail'], fn: () => MessageEmbedImage.fromJson(json['thumbnail'])),
      video:
          createOrNull(field: json['video'], fn: () => MessageEmbedImage.fromJson(json['video'])),
      footer: createOrNull(
          field: json['footer'], fn: () => MessageEmbedFooter.fromJson(json['footer'])),
      author: createOrNull(
          field: json['author'], fn: () => MessageEmbedAuthor.fromJson(json['author'])),
      color: json['color'],
    );
  }
}
