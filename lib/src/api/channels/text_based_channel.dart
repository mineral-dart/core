import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/channels/permission_overwrite.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';
import 'package:mineral/src/api/managers/webhook_manager.dart';
import 'package:mineral/src/api/managers/thread_manager.dart';
import 'package:mineral/src/internal/extensions/mineral_client.dart';


class TextBasedChannel extends Channel {
  String? description;
  bool nsfw;
  Snowflake? lastMessageId;
  DateTime? lastPinTimestamp;
  MessageManager messages;
  ThreadManager threads;

  TextBasedChannel({
    required Snowflake id,
    required Snowflake? guildId,
    required int? position,
    required String label,
    required Snowflake? applicationId,
    required Snowflake? parentId,
    required int? flags,
    required this.description,
    required this.nsfw,
    required this.lastMessageId,
    required this.lastPinTimestamp,
    required this.messages,
    required this.threads,
    required PermissionOverwriteManager permissionOverwrites
  }) : super(
    id: id,
    type: ChannelType.guildText,
    guildId: guildId,
    position: position,
    label: label,
    applicationId: applicationId,
    parentId: parentId,
    flags: flags,
    webhooks: WebhookManager(guildId: guildId, channelId: id),
    permissionOverwrites: permissionOverwrites
  );

  Future<Message?> send ({ String? content, List<MessageEmbed>? embeds, List<Row>? components, bool? tts }) async {
    MineralClient client = ioc.singleton(ioc.services.client);

    Response response = await client.sendMessage(this,
      content: content,
      embeds: embeds,
      components: components
    );

    if (response.statusCode == 200) {
      dynamic payload = jsonDecode(response.body);

      Message message = Message.from(channel: this, payload: payload);
      messages.cache.putIfAbsent(message.id, () => message);

      return message;
    }

    return null;
  }



  Future<dynamic> setDescription (String description) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/channels/$id", payload: { 'topic': description });

    if (response.statusCode == 200) {
      this.description = description;
    }

    return this;
  }

  Future<dynamic> setNsfw (bool value) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/channels/$id", payload: { 'nsfw': value });

    if (response.statusCode == 200) {
      nsfw = value;
    }

    return this;
  }

  Future<TextChannel?> update ({ String? label, String? description, int? delay, int? position, CategoryChannel? categoryChannel, bool? nsfw, List<PermissionOverwrite>? permissionOverwrites }) async {
    Http http = ioc.singleton(ioc.services.http);

    Response response = await http.patch(url: "/channels/$id", payload: {
      'name': label ?? this.label,
      'topic': description,
      'parent_id': categoryChannel?.id,
      'nsfw': nsfw ?? false,
      'rate_limit_per_user': delay ?? 0,
      'permission_overwrites': permissionOverwrites?.map((e) => e.toJSON()).toList(),
    });

    dynamic payload = jsonDecode(response.body);
    TextChannel channel = TextChannel.from(payload);

    // Define deep properties
    channel.guildId = guildId;
    channel.guild = guild;
    channel.parent = channel.parentId != null ? guild?.channels.cache.get<CategoryChannel>(channel.parentId) : null;

    guild?.channels.cache.set(channel.id, channel);
    return channel;
  }
}
