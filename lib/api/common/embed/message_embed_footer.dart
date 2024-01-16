import 'package:mineral/domains/shared/utils.dart';

final class MessageEmbedFooter {
  final String text;
  final String? iconUrl;
  final String? proxyIconUrl;

  MessageEmbedFooter(
      {required this.text, required this.iconUrl, required this.proxyIconUrl }) {
    expectOrThrow(text.length <= 2048, message: 'Text must be 2048 or fewer in length');
  }

  Object toJson() {
    return {
      'text': text,
      'icon_url': iconUrl,
      'proxy_icon_url': proxyIconUrl,
    };
  }

  factory MessageEmbedFooter.fromJson(Map<String, dynamic> json) {
    return MessageEmbedFooter(
      text: json['text'],
      iconUrl: json['icon_url'],
      proxyIconUrl: json['proxy_icon_url'],
    );
  }
}
