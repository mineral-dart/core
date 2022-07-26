import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/components/component.dart';
import 'package:mineral/src/api/messages/message_attachment.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class Message extends PartialMessage<TextBasedChannel> {
  GuildMember author;

  Message({
    required id,
    required content,
    required tts,
    required embeds,
    required allowMentions,
    required reference,
    required components,
    required stickers,
    required payload,
    required attachments,
    required flags,
    required channelId,
    required channel,
    required this.author,
  }): super(
    id: id,
    content: content,
    tts: tts,
    embeds: embeds,
    allowMentions: allowMentions,
    reference: reference,
    components: components,
    stickers: stickers,
    payload: payload,
    attachments: attachments,
    flags: flags,
    channelId: channelId,
    channel: channel,
  );

  Future<Message> edit ({ String? content, List<MessageEmbed>? embeds, List<Row>? components, bool? tts }) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(
        url: '/channels/$channelId/messages/$id',
        payload: {
          'content': content,
          'embeds': embeds,
          'flags': flags,
          'allowed_mentions': allowMentions,
          'components': components,
        }
    );

    print(response.body);
    if (response.statusCode == 200) {
      this.content = content ?? this.content;
      this.embeds = embeds ?? this.embeds;
      this.components = components ?? this.components;
    }

    return this;
  }

  factory Message.from({ required TextBasedChannel channel, required dynamic payload }) {
    print(channel.guild);
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
