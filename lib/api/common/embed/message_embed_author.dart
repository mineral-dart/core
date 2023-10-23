final class MessageEmbedAuthor {
  final String name;
  final Uri? url;
  final Uri? iconUrl;
  final Uri? proxyIconUrl;

  MessageEmbedAuthor({
    required this.name,
    this.url,
    this.iconUrl,
    this.proxyIconUrl
  });

  Map<String, String?> get serializeAsJson => {
    'name': name,
    'url': url?.toString(),
    'icon_url': iconUrl?.toString(),
    'proxy_icon_url': proxyIconUrl?.toString()
  };
}