import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral_ioc/ioc.dart';

extension MineralClientExtension on MineralClient {
  Future<Response> sendMessage (PartialChannel channel, { String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, bool? tts, Map<String, Snowflake>? messageReference }) async {
    Http http = ioc.singleton(Service.http);

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

    return await http.post(url: '/channels/${channel.id}/messages', payload: {
      'tts': tts ?? false,
      'content': content,
      'embeds': embeds != null ? embedList : [],
      'components': components != null ? componentList : [],
      'message_reference': messageReference != null ? { ...messageReference, 'fail_if_not_exists': true } : null,
    });
  }

  Future<T?> createChannel<T extends GuildChannel> (Snowflake guildId, ChannelBuilder builder) async {
    Http http = ioc.singleton(Service.http);

    Response response = await http.post(url: "/guilds/$guildId/channels", payload: builder.payload);
    final payload = jsonDecode(response.body);

    final channel = ChannelWrapper.create(payload);
    return channel as T?;
  }
}
