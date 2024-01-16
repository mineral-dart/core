import 'package:mineral/domains/shared/utils.dart';

final class MessageEmbedAuthor {
  final String name;
  final String? url;
  final String? iconUrl;
  final String? proxyIconUrl;

  MessageEmbedAuthor(
      {required this.name, required this.url, required this.iconUrl, required this.proxyIconUrl}) {
    expectOrThrow(name.length <= 256, message: 'Author name must be 256 or fewer in length');
  }

  Object toJson() {
    return {
      'name': name,
      'url': url,
      'icon_url': iconUrl,
      'proxy_icon_url': proxyIconUrl,
    };
  }

  factory MessageEmbedAuthor.fromJson(Map<String, dynamic> json) {
    return MessageEmbedAuthor(
      name: json['name'],
      url: json['url'],
      iconUrl: json['icon_url'],
      proxyIconUrl: json['proxy_icon_url'],
    );
  }
}
