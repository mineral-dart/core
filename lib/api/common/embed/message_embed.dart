import 'package:mineral/api/common/embed/color.dart';

final class MessageEmbed {
  final String? title;
  final String? description;
  final Uri? url;
  final DateTime? timestamp;
  final Color? color;

  MessageEmbed({
    this.title,
    this.description,
    this.url,
    this.timestamp,
    this.color
  });
}