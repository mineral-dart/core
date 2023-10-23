final class MessageEmbedFooter {
  final String text;
  final Uri? iconUrl;
  final Uri? proxyIconUrl;

  MessageEmbedFooter({
    required this.text,
    this.iconUrl,
    this.proxyIconUrl
  });

  Map<String, String?> get serializeAsJson => {
    'text': text,
    'icon_url': iconUrl?.toString(),
    'proxy_icon_url': proxyIconUrl?.toString()
  };
}