import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/builders/component_builder.dart';
import 'package:mineral/src/api/managers/message_reaction_manager.dart';
import 'package:mineral/src/api/messages/message_attachment.dart';
import 'package:mineral/src/api/messages/message_mention.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral/src/internal/mixins/mineral_client.dart';
import 'package:mineral_cli/mineral_cli.dart';
import 'package:mineral_ioc/ioc.dart';

class Message extends PartialMessage<TextBasedChannel>  {
  Snowflake _authorId;
  final MessageMention _mentions;

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
    super._pinned,
    super._guildId,
    super._channelId,
    super._reactions,
    super.timestamp,
    super.editedTimestamp,
    this._authorId,
    this._mentions,
  );

  GuildMember? get author => channel.guild.members.cache.get(_authorId);

  @override
  GuildChannel get channel => super.channel as GuildChannel;

  MessageMention get mentions => _mentions;

  Future<Message?> edit ({ String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, bool? tts }) async {

    Response response = await ioc.use<HttpService>().patch(
      url: '/channels/${channel.id}/messages/$id',
      payload: {
        'content': content,
        'embeds': embeds,
        'flags': flags,
        'allowed_mentions': allowMentions,
        'components': components,
      }
    );

    return response.statusCode == 200
      ? Message.from(channel: channel, payload: jsonDecode(response.body))
      : null;
  }

  Future<void> crossPost () async {
    if (channel.type != ChannelType.guildNews) {
      ioc.use<MineralCli>().console.warn('Message $id cannot be cross-posted as it is not in an announcement channel');
      return;
    }

    await ioc.use<HttpService>().post(url: '/channels/${super.channel.id}/messages/${super.id}/crosspost', payload: {});
  }

  Future<void> pin (Snowflake webhookId) async {
    if (isPinned) {
      ioc.use<MineralCli>().console.warn('Message $id is already pinned');
      return;
    }

    await ioc.use<HttpService>().put(url: '/channels/${channel.id}/pins/$id', payload: {});
  }

  Future<void> unpin () async {
    if (!isPinned) {
      ioc.use<MineralCli>().console.warn('Message $id isn\'t pinned');
      return;
    }

    await ioc.use<HttpService>().destroy(url: '/channels/${channel.id}/pins/$id');
  }

  Future<PartialMessage?> reply ({ String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, List<MessageAttachmentBuilder>? attachments, bool? tts }) async {
    MineralClient client = ioc.use<MineralClient>();

    Response response = await client.sendMessage(channel,
      content: content,
      embeds: embeds,
      components: components,
      messageReference: {
        'guild_id': channel.guild.id,
        'channel_id': channel.id,
        'message_id': id,
      },
      attachments: attachments
    );

    if (response.statusCode == 200) {
      Message message = Message.from(channel: channel, payload: jsonDecode(response.body));

      if (channel is CategoryChannel) {
        (channel as TextBasedChannel).messages.cache.putIfAbsent(message.id, () => message);
      }

      if (channel is PartialTextChannel) {
        (channel as PartialTextChannel).messages.cache.putIfAbsent(message.id, () => message);
      }

      return message;
    }

    return null;
  }

  factory Message.from({ required GuildChannel channel, required dynamic payload }) {
    List<EmbedBuilder> embeds = [];
    if (payload['embeds'] != null) {
      for (dynamic element in payload['embeds']) {
        List<Field> fields = [];
        if (element['fields'] != null) {
          for (dynamic item in element['fields']) {
            Field field = Field(name: item['name'], value: item['value'], inline: item['inline'] ?? false);
            fields.add(field);
          }
        }

        EmbedBuilder embed = EmbedBuilder(
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

    List<ComponentBuilder> components = [];
    if (payload['components'] != null) {
      for (dynamic element in payload['components']) {
        final component = ComponentBuilder.wrap(element, payload['guild_id']);
        components.add(component);
      }
    }

    List<Snowflake> memberMentions = [];
    if (payload['mentions'] != null) {
      for (final element in payload['mentions']) {
        memberMentions.add(element['id']);
      }
    }

    List<Snowflake> roleMentions = [];
    if (payload['mention_roles'] != null) {
      for (final element in payload['mention_roles']) {
        roleMentions.add(element);
      }
    }

    List<Snowflake> channelMentions = [];
    if (payload['mention_channels'] != null) {
      for (final element in payload['mention_channels']) {
        channelMentions.add(element['id']);
      }
    }

    final message = Message(
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
      payload['pinned'],
      channel.guild.id,
      payload['channel_id'],
      MessageReactionManager<GuildChannel, Message>(channel),
      payload['timestamp'],
      payload['edited_timestamp'],
      payload['author']['id'],
      MessageMention(channel, channelMentions, memberMentions, roleMentions, payload['mention_everyone'] ?? false)
    );

    message.reactions.message = message;

    return message;
  }
}
