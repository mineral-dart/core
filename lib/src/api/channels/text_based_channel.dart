import 'dart:convert';

import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/thread_manager.dart';
import 'package:mineral/src/internal/extensions/mineral_client.dart';


class TextBasedChannel extends Channel {
  Channel? _parent;
  String? _description;
  bool _nsfw;
  final Snowflake? _lastMessageId;
  final DateTime? _lastPinTimestamp;
  final MessageManager _messages;
  final ThreadManager _threads;

  TextBasedChannel(
    super._id,
    super._type,
    super._position,
    super.label,
    super._applicationId,
    super.flags,
    super._webhooks,
    super._permissionOverwrites,
    super._guild,
    this._description,
    this._nsfw,
    this._lastMessageId,
    this._lastPinTimestamp,
    this._messages,
    this._threads,
  );

  @override
  Channel? get parent => _parent;

  String? get description => _description;
  bool get isNsfw => _nsfw;
  Snowflake? get lastMessageId => _lastMessageId;
  DateTime? get lastPinTimestamp => _lastPinTimestamp;
  MessageManager get messages => _messages;
  ThreadManager get threads => _threads;

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
      _description = description;
    }

    return this;
  }

  Future<dynamic> setNsfw (bool value) async {
    Http http = ioc.singleton(ioc.services.http);
    Response response = await http.patch(url: "/channels/$id", payload: { 'nsfw': value });

    if (response.statusCode == 200) {
      _nsfw = value;
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
    TextChannel channel = TextChannel.from(guild, payload);

    channel.parent = payload['parent_id'] != null
      ? guild?.channels.cache.get<CategoryChannel>(payload['parent_id'])
      : null;

    guild?.channels.cache.set(channel.id, channel);
    return channel;
  }
}
