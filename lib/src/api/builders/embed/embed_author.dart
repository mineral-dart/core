import 'package:mineral/core/builders.dart';

/// An image for an [EmbedBuilder].
class EmbedAuthor {
  /// Name of this
  String name;

  /// Url of this
  String? url;

  /// Icon url of this
  String? iconUrl;

  /// Proxy icon url of this
  String? proxyIconUrl;

  EmbedAuthor({ required this.name, this.url, this.iconUrl, this.proxyIconUrl });

  /// Converts the [EmbedAuthor] to a [Map] that can be serialized to JSON.
  Object toJson () => {
    'name': name,
    'url': url,
    'icon_url': iconUrl,
    'proxy_icon_url': proxyIconUrl,
  };
}