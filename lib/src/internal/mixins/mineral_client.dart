import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:path/path.dart';

extension MineralClientExtension on MineralClient {
  Future<Response> sendMessage (PartialChannel channel, { String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, List<MessageAttachmentBuilder>? attachments, bool? tts, Map<String, Snowflake>? messageReference }) async {
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
        files.add(await MultipartFile.fromPath("files[$i]", join(Directory.current.path, attachments[i].url)));
        attachmentList.add(attachments[i].toJson(id: i));
      }

      payload['attachments'] = attachmentList;
      return await ioc.use<HttpService>().postWithFiles(url: '/channels/${channel.id}/messages', files: files, payload: payload);
    }

    return await ioc.use<HttpService>().post(url: '/channels/${channel.id}/messages', payload: payload);
  }

  Future<T?> createChannel<T extends GuildChannel> (Snowflake guildId, ChannelBuilder builder) async {
    Response response = await ioc.use<HttpService>().post(url: "/guilds/$guildId/channels", payload: builder.payload);
    final payload = jsonDecode(response.body);

    final channel = ChannelWrapper.create(payload);
    return channel as T?;
  }
}
