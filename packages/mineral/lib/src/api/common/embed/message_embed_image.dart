final class MessageEmbedImage {
  final String url;
  final String? proxyUrl;
  final int? height;
  final int? width;

  const MessageEmbedImage({
    required this.url,
    required this.proxyUrl,
    required this.height,
    required this.width,
  });

  Object toJson() {
    return {
      'url': url,
      'proxy_url': proxyUrl,
      'height': height,
      'width': width,
    };
  }

  factory MessageEmbedImage.fromJson(Map<String, dynamic> raw) {
    return MessageEmbedImage(
      url: raw['url'],
      proxyUrl: raw['proxy_url'],
      height: raw['height'],
      width: raw['width'],
    );
  }
}
