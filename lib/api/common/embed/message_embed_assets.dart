import 'package:mineral/api/common/embed/message_embed_author.dart';
import 'package:mineral/api/common/embed/message_embed_color.dart';
import 'package:mineral/api/common/embed/message_embed_footer.dart';
import 'package:mineral/api/common/embed/message_embed_image.dart';
import 'package:mineral/infrastructure/commons/helper.dart';

final class MessageEmbedAssets {
  final MessageEmbedImage? image;
  final MessageEmbedImage? thumbnail;
  final MessageEmbedImage? video;
  final MessageEmbedFooter? footer;
  final MessageEmbedAuthor? author;
  final MessageEmbedColor color;

  const MessageEmbedAssets({
    required this.image,
    required this.thumbnail,
    required this.video,
    required this.footer,
    required this.author,
    required this.color,
  });

  Object toJson() {
    return {
      'image': image?.toJson(),
      'thumbnail': thumbnail?.toJson(),
      'video': video?.toJson(),
      'footer': footer?.toJson(),
      'author': author?.toJson(),
      'color': color,
    };
  }

  factory MessageEmbedAssets.fromJson(Map<String, dynamic> json) {
    return MessageEmbedAssets(
      image: Helper.createOrNull(
          field: json['image'], fn: () => MessageEmbedImage.fromJson(json['image'])),
      thumbnail: Helper.createOrNull(
          field: json['thumbnail'], fn: () => MessageEmbedImage.fromJson(json['thumbnail'])),
      video: Helper.createOrNull(
          field: json['video'], fn: () => MessageEmbedImage.fromJson(json['video'])),
      footer: Helper.createOrNull(
          field: json['footer'], fn: () => MessageEmbedFooter.fromJson(json['footer'])),
      author: Helper.createOrNull(
          field: json['author'], fn: () => MessageEmbedAuthor.fromJson(json['author'])),
      color: json['color'],
    );
  }
}
