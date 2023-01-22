import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/channels/partial_channel.dart';
import 'package:mineral/src/api/messages/message_parser.dart';
import 'package:mineral_ioc/ioc.dart';

extension MineralClientExtension on MineralClient {
  Future<Response> sendMessage (PartialChannel channel, { String? content, List<EmbedBuilder>? embeds, List<RowBuilder>? components, List<AttachmentBuilder>? attachments, bool? tts, Map<String, Snowflake>? messageReference }) async {
    dynamic messagePayload = MessageParser(content, embeds, components, attachments, tts).toJson();

    return await ioc.use<DiscordApiHttpService>().post(url: "/channels/${channel.id}/messages")
        .files(messagePayload['files'])
        .payload({
          ...messagePayload['payload'],
          'message_reference': messageReference != null ? { ...messageReference, 'fail_if_not_exists': true } : null,
        })
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
