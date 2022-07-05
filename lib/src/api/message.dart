import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/components/component.dart';
import 'package:mineral/src/api/message_attachment.dart';
import 'package:mineral/src/api/message_embed.dart';
import 'package:mineral/src/api/message_sticker_item.dart';

class Message {
  Snowflake id;
  String content;
  bool tts;
  List<MessageEmbed> embeds;
  bool allowMentions;
  Message? reference;
  List<Component> components;
  List<MessageStickerItem> stickers;
  dynamic payload;
  List<MessageAttachment> attachments;
  int? flags;
  Snowflake channelId;
  TextBasedChannel channel;
  GuildMember author;

  Message({
    required this.id,
    required this.content,
    required this.tts,
    required this.embeds,
    required this.allowMentions,
    required this.reference,
    required this.components,
    required this.stickers,
    required this.payload,
    required this.attachments,
    required this.flags,
    required this.channelId,
    required this.channel,
    required this.author,
  });

  Future<Message> sync () async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.get(url: "/channels/${channel.id}");
    dynamic payload = jsonDecode(response.body);

    Message message = Message.from(channel: channel, payload: payload);
    channel.messages.cache.set(message.id, message);

    return message;
  }

  factory Message.from({ required TextBasedChannel channel, required dynamic payload }) {
    GuildMember? guildMember = channel.guild?.members.cache.get(payload['author']['id']);
    List<MessageEmbed> embeds = [];

    for (dynamic element in payload['embeds']) {
      List<Field> fields = [];
      if (element['fields'] != null) {
        for (dynamic item in element['fields']) {
          Field field = Field(name: item['name'], value: item['value'], inline: item['inline'] ?? false);
          fields.add(field);
        }
      }

      MessageEmbed embed = MessageEmbed(
        title: element['title'],
        description: element['description'],
        url: element['url'],
        timestamp: element['timestamp'] != null ? DateTime.parse(element['timestamp']) : null,
        footer: element['footer'] != null ? Footer(
          text: element['footer']['text'],
          iconUrl: element['footer']['icon_url'],
          proxyIconUrl: element['footer']['proxy_icon_url'],
        ) : null,
        image: element['image'] != null ? Image(
          url: element['image']['url'],
          proxyUrl: element['image']['proxy_url'],
          height: element['image']['height'],
          width: element['image']['width'],
        ) : null,
        author: element['author'] != null ? Author(
          name: element['author']['name'],
          url: element['author']['url'],
          proxyIconUrl: element['author']['proxy_icon_url'],
          iconUrl: element['author']['icon_url'],
        ) : null,
        fields: fields,
      );

      embeds.add(embed);
    }

    List<MessageStickerItem> stickers = [];
    if (payload['sticker_items'] != null) {
      for (dynamic element in payload['sticker_items']) {
        MessageStickerItem sticker = MessageStickerItem.from(element);
        stickers.add(sticker);
      }
    }

    List<MessageAttachment> messageAttachments = [];
    if (payload['attachments'] != null) {
      for (dynamic element in payload['attachments']) {
        MessageAttachment attachment = MessageAttachment.from(element);
        messageAttachments.add(attachment);
      }
    }

    List<Component> components = [];
    for (dynamic payload in payload['components']) {
      Component component = Component.from(payload: payload);
      components.add(component);
    }

    return Message(
      id: payload['id'],
      content: payload['content'],
      tts: payload['tts'] ?? false,
      allowMentions: payload['allow_mentions'] ?? false,
      reference: payload['reference'],
      flags: payload['flags'],
      channelId: channel.id,
      channel: channel,
      author: guildMember!,
      embeds: embeds,
      components: components,
      payload: payload['payload'],
      stickers: stickers,
      attachments: messageAttachments,
    );
  }
}
