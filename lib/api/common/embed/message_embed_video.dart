final class MessageEmbedVideo {
  final Uri url;
  final Uri? proxyUrl;
  final int? width;
  final int? height;

  MessageEmbedVideo({
    required this.url,
    this.proxyUrl,
    this.width,
    this.height
  });

  Map<String, String?> get serializeAsJson => {
    'url': url.toString(),
    'proxy_url': proxyUrl?.toString(),
    'width': width?.toString(),
    'height': height?.toString()
  };
}