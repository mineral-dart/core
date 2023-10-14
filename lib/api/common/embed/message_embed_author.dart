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
}