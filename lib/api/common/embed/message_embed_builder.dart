import 'package:mineral/api/common/embed/color.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/embed/message_embed_author.dart';
import 'package:mineral/api/common/embed/message_embed_field.dart';
import 'package:mineral/api/common/embed/message_embed_footer.dart';
import 'package:mineral/api/common/embed/message_embed_image.dart';
import 'package:mineral/api/common/embed/message_embed_video.dart';

final class MessageEmbedBuilder {
  String? title;
  String? description;
  Uri? url;
  DateTime? timestamp;
  Color? color;
  MessageEmbedFooter? footer;
  MessageEmbedImage? image;
  MessageEmbedImage? thumbnail;
  MessageEmbedVideo? video;
  MessageEmbedAuthor? author;
  List<MessageEmbedField> fields = const [];

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

  MessageEmbedBuilder setFooter (String text, { Uri? iconUrl, Uri? proxyIconUrl }) {
    footer = MessageEmbedFooter(
      text: text,
      iconUrl: iconUrl,
      proxyIconUrl: proxyIconUrl
    );

    return this;
  }

  MessageEmbedBuilder setImage (Uri url, { Uri? proxyUrl, int? height, int? width }) {
    image = MessageEmbedImage(
      url: url,
      proxyUrl: proxyUrl,
      height: height,
      width: width
    );

    return this;
  }

  MessageEmbedBuilder setThumbnail (Uri url, { Uri? proxyUrl, int? height, int? width }) {
    thumbnail = MessageEmbedImage(
      url: url,
      proxyUrl: proxyUrl,
      height: height,
      width: width
    );

    return this;
  }

  MessageEmbedBuilder setVideo (Uri url, { Uri? proxyUrl, int? height, int? width }) {
    video = MessageEmbedVideo(
      url: url,
      proxyUrl: proxyUrl,
      height: height,
      width: width
    );

    return this;
  }

  MessageEmbedBuilder setAuthor (String name, { Uri? url, Uri? iconUrl, Uri? proxyIconUrl }) {
    author = MessageEmbedAuthor(
      name: name,
      url: url,
      iconUrl: iconUrl,
      proxyIconUrl: proxyIconUrl,
    );

    return this;
  }

  MessageEmbedBuilder addField (String name, dynamic value, { bool inline = false }) {
    fields.add(
      MessageEmbedField(
        name: name,
        value: value.toString(),
        inline: inline
      )
    );

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

  factory MessageEmbedBuilder.of(MessageEmbed embed) {
    final builder = MessageEmbedBuilder();

    if (embed.title != null) {
      builder.setTitle(embed.title!);
    }

    if (embed.description != null) {
      builder.setDescription(embed.description!);
    }

    if (embed.url != null) {
      builder.setUrl(embed.url!);
    }

    if (embed.timestamp != null) {
      builder.setTimestamp(embed.timestamp!);
    }

    if (embed.color != null) {
      builder.setColor(embed.color!);
    }

    if (embed.footer != null) {
      builder.setFooter(
        embed.footer!.text,
        iconUrl: embed.footer!.iconUrl,
        proxyIconUrl: embed.footer!.proxyIconUrl
      );
    }

    if (embed.image != null) {
      builder.setImage(
        embed.image!.url,
        proxyUrl: embed.image!.proxyUrl,
        height: embed.image!.height,
        width: embed.image!.width
      );
    }

    if (embed.thumbnail != null) {
      builder.setThumbnail(
        embed.thumbnail!.url,
        proxyUrl: embed.thumbnail!.proxyUrl,
        height: embed.thumbnail!.height,
        width: embed.thumbnail!.width
      );
    }

    if (embed.video != null) {
      builder.setVideo(
        embed.video!.url,
        proxyUrl: embed.video!.proxyUrl,
        height: embed.video!.height,
        width: embed.video!.width
      );
    }

    if (embed.author != null) {
      builder.setAuthor(
        embed.author!.name,
        url: embed.author!.url,
        iconUrl: embed.author!.iconUrl,
        proxyIconUrl: embed.author!.proxyIconUrl
      );
    }

    if (embed.fields.isNotEmpty) {
      for (final field in embed.fields) {
        builder.addField(
          field.name,
          field.value,
          inline: field.inline
        );
      }
    }

    return builder;
  }
}