import 'package:mineral/core/builders.dart';

/// Footer of an [EmbedBuilder].
class EmbedFooter {
  /// Footer text.
  String text;

  /// Url of footer icon.
  String? iconUrl;

  /// A proxy url of footer icon.
  String? proxyIconUrl;

  EmbedFooter({ required this.text, this.iconUrl, this.proxyIconUrl });

  /// Converts the [EmbedFooter] to a JSON object.
  Object toJson () => {
    'text': text,
    'icon_url': iconUrl,
    'proxy_icon_url': proxyIconUrl,
  };
}