import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral_ioc/ioc.dart';

extension MineralClientExtension on MineralClient {
  Future<Response> sendMessage (PartialChannel channel, { String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, List<AttachmentBuilder>? attachments, bool? tts, Map<String, Snowflake>? messageReference }) async {
    List<dynamic> embedList = [];
    if (embeds != null) {
      for (EmbedBuilder element in embeds) {
        embedList.add(element.toJson());
      }
    }

    List<dynamic> componentList = [];
    if (components != null) {
      for (RowBuilder element in components) {
        componentList.add(element.toJson());
      }
    }

    dynamic payload = {
        'tts': tts ?? false,
        'content': content,
        'embeds': embeds != null ? embedList : [],
        'components': components != null ? componentList : [],
        'message_reference': messageReference != null ? { ...messageReference, 'fail_if_not_exists': true } : null,
    };

    if (attachments != null) {
      List<MultipartFile> files = [];
      List<dynamic> attachmentList = [];

      for (int i = 0; i < attachments.length; i++) {
        AttachmentBuilder attachment = attachments[i];
        attachmentList.add(attachment.toJson(id: i));
        files.add(attachment.toFile(i));
      }

      payload['attachments'] = attachmentList;
      return await ioc.use<DiscordApiHttpService>().post(url: '/channels/${channel.id}/messages')
        .payload(payload)
        .files(files)
        .build();
    }

    return await ioc.use<DiscordApiHttpService>().post(url: '/channels/${channel.id}/messages')
      .payload(payload)
      .build();
  }

  Future<T?> createChannel<T extends GuildChannel> (Snowflake guildId, ChannelBuilder builder) async {
    Response response = await ioc.use<DiscordApiHttpService>().post(url: "/guilds/$guildId/channels")
      .payload(builder.payload)
      .build();

    final payload = jsonDecode(response.body);

    final channel = ChannelWrapper.create(payload);
    return channel as T?;
  }
}
