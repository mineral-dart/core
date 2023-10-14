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
}