final class MessageMedia {
  final String url;
  final String? proxyUrl;
  final int? height;
  final int? width;
  final String? contentType;

  MessageMedia({
    required this.url,
    this.proxyUrl,
    this.height,
    this.width,
    this.contentType,
  });
}
