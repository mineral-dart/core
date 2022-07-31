import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/components/component.dart';
import 'package:mineral/src/api/messages/message_attachment.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';
import 'package:mineral/src/api/messages/partial_message.dart';

class Message extends PartialMessage<TextBasedChannel> {
  GuildMember? _author;

  Message(
    super._id,
    super._content,
    super._tts,
    super._embeds,
    super._allowMentions,
    super._reference,
    super._components,
    super._stickers,
    super._payload,
    super._attachments,
    super._flags,
    super._channelId,
    super._channel,
    this._author,
  );

  GuildMember? get author => _author;

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

    if (response.statusCode == 200) {
      this.content = content ?? this.content;
      this.embeds = embeds ?? this.embeds;
      this.components = components ?? this.components;
    }

    return this;
  }

  Future<void> crossPost () async {
    if (channel.type != ChannelType.guildNews) {
      Console.warn(message: 'Message $id cannot be cross-posted as it is not in an announcement channel');
      return;
    }

    Http http = ioc.singleton(ioc.services.http);
    await http.post(url: '/channels/${super.channel.id}/messages/${super.id}/crosspost', payload: {});
  }

  Future<void> pin (Snowflake webhookId) async {
    Http http = ioc.singleton(ioc.services.http);
    await http.put(url: '/channels/${channel.id}/pins/$id', payload: {});
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
      payload['id'],
      payload['content'],
      payload['tts'] ?? false,
      embeds,
      payload['allow_mentions'] ?? false,
      payload['reference'],
      components,
      stickers,
      payload['payload'],
      messageAttachments,
      payload['flags'],
      channel.id,
      channel,
      guildMember,
    );
  }
}
