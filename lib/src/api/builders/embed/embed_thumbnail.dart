import 'package:mineral/core/builders.dart';

/// An image for an [EmbedBuilder].
class EmbedThumbnail {
  /// The source url of the thumbnail
  String url;

  /// A proxy url of the thumbnail
  String? proxyUrl;

  /// The height of the thumbnail
  int? height;

  /// The width of the thumbnail
  int? width;

  EmbedThumbnail({ required this.url, this.proxyUrl, this.height, this.width });

  /// Converts the [EmbedThumbnail] to a [Map] that can be serialized to JSON.
  Object toJson () => {
    'url': url,
    'proxy_url': proxyUrl,
    'width': width,
    'height': height,
  };
}