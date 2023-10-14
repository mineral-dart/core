import 'package:mineral/api/common/embed/color.dart';
import 'package:mineral/api/common/embed/message_embed.dart';

final class MessageEmbedBuilder {
  String? title;
  String? description;
  Uri? url;
  DateTime? timestamp;
  Color? color;

  MessageEmbedBuilder();

  MessageEmbedBuilder setTitle(String title) {
    this.title = title;
    return this;
  }

  MessageEmbedBuilder setDescription(String description) {
    this.description = description;
    return this;
  }

  MessageEmbedBuilder setUrl(Uri url) {
    this.url = url;
    return this;
  }

  MessageEmbedBuilder setTimestamp(DateTime timestamp) {
    this.timestamp = timestamp;
    return this;
  }

  MessageEmbedBuilder setColor(Color color) {
    this.color = color;
    return this;
  }

  MessageEmbed build() {
    return MessageEmbed(
      title: title,
      description: description,
      url: url,
      timestamp: timestamp,
      color: color
    );
  }
}