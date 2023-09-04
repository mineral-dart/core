import 'package:mineral/core/builders.dart';

/// An image for an [EmbedBuilder].
class EmbedImage {
  /// Source url of the image.
  String url;

  /// A proxy url of the image.
  String? proxyUrl;

  /// The width of the image.
  int? width;

  /// The height of the image.
  int? height;

  EmbedImage({ required this.url, this.proxyUrl, this.width, this.height });

  /// Converts the [EmbedImage] to a [Map] that can be serialized to JSON.
  Object toJson () => {
    'url': url,
    'proxy_url': proxyUrl,
    'width': width,
    'height': height,
  };
}