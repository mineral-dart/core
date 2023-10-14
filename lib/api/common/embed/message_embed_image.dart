final class MessageEmbedImage {
  final Uri url;
  final Uri? proxyUrl;
  final int? width;
  final int? height;

  MessageEmbedImage({
    required this.url,
    this.proxyUrl,
    this.width,
    this.height
  });
}