import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/managers/message_reaction_manager.dart';
import 'package:mineral/src/api/messages/message_attachment.dart';
import 'package:mineral/src/api/messages/message_parser.dart';
import 'package:mineral/src/api/messages/message_sticker_item.dart';
import 'package:mineral/src/api/messages/partial_message.dart';
import 'package:mineral_ioc/ioc.dart';

class DmMessage extends PartialMessage<DmChannel>  {
  User author;

  DmMessage(
    super.id,
    super.content,
    super.tts,
    super.embeds,
    super.allowMentions,
    super.reference,
    super.components,
    super.stickers,
    super.payload,
    super.attachments,
    super.flags,
    super.pinned,
    super._guildId,
    super.channelId,
    super.reactions,
    super.timestamp,
    super.editedTimestamp,
    this.author,
  );

  Future<DmMessage?> edit ({ String? content, List<EmbedBuilder>? embeds, ComponentBuilder? components, List<AttachmentBuilder>? attachments, bool? tts }) async {
    dynamic messagePayload = MessageParser(content, embeds, components, attachments, null).toJson();

    Response response = await ioc.use<DiscordApiHttpService>().patch(url: '/channels/${channel.id}/messages/$id')
        .files(messagePayload['files'])
        .payload({
      ...messagePayload['payload'],
      'flags': flags,
      'allowed_mentions': allowMentions
    })
        .build();

    return response.statusCode == 200
        ? DmMessage.from(channel: channel, payload: jsonDecode(response.body))
        : null;
  }

  /// Delete this
  @override
  Future<void> delete ({ String? reason }) async {
    await ioc.use<DiscordApiHttpService>()
      .destroy(url: '/channels/${channel.id}/messages/$id')
      .auditLog(reason)
      .build();
  }

  factory DmMessage.from({ required DmChannel channel, required dynamic payload }) {
    MineralClient client = ioc.use<MineralClient>();
    User? user = client.users.cache.get(payload['author']['id']);

    List<EmbedBuilder> embeds = [];
    if (payload['embeds'] != null) {
      for (dynamic element in payload['embeds']) {
        embeds.add(EmbedBuilder.from(element));
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

    ComponentBuilder componentBuilder = ComponentBuilder();
    if (payload['components'] != null) {
      for (dynamic element in payload['components']) {
        componentBuilder.rows.add(ComponentWrapper.wrap(element, payload['guild_id']));
      }
    }

    final message = DmMessage(
      payload['id'],
      payload['content'],
      payload['tts'] ?? false,
      embeds,
      payload['allow_mentions'] ?? false,
      payload['reference'],
      componentBuilder,
      stickers,
      payload['payload'],
      messageAttachments,
      payload['flags'],
      payload['pinned'],
      null,
      channel.id,
      MessageReactionManager<DmChannel, DmMessage>(channel),
      payload['timestamp'],
      payload['edited_timestamp'],
      user!,
    );

    message.reactions.message = message;

    return message;
  }
}
