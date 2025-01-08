import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/infrastructure/internals/http/discord_header.dart';
import 'package:mineral/src/infrastructure/services/http/http_request_option.dart';

final class EmojiPart implements EmojiPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, Emoji>> fetch(String serverId, bool force) async {
    final completer = Completer<Map<Snowflake, Emoji>>();

    final result = await _dataStore.requestBucket
        .run<List>(() => _dataStore.client.get('/guilds/$serverId/emojis'));

    final emojis = await result.map((element) async {
      final raw = await _marshaller.serializers.emojis.normalize(element);
      return _marshaller.serializers.emojis.serialize(raw);
    }).wait;

    completer.complete(emojis.asMap().map((_, value) => MapEntry(value.id!, value)));

    return completer.future;
  }

  @override
  Future<Emoji?> get(String serverId, String emojiId, bool force) async {
    final completer = Completer<Emoji>();
    final String key = _marshaller.cacheKey.serverEmoji(serverId, emojiId);

    final cachedEmoji = await _marshaller.cache?.get(key);
    if (!force && cachedEmoji != null) {
      final emoji = await _marshaller.serializers.emojis.serialize(cachedEmoji);
      completer.complete(emoji);

      return completer.future;
    }

    final result = await _dataStore.requestBucket.run<Map<String, dynamic>>(
        () => _dataStore.client.get('/guilds/$serverId/emojis/$emojiId'));

    final raw = await _marshaller.serializers.emojis.normalize(result);
    final emoji = await _marshaller.serializers.emojis.serialize(raw);

    completer.complete(emoji);

    return completer.future;
  }

  @override
  Future<Emoji> create(String serverId, String name, Image image, List<String> roles,
      {String? reason}) async {
    final completer = Completer<Emoji>();

    final result = await _dataStore.requestBucket
        .run<Map<String, dynamic>>(() => _dataStore.client.post('/guilds/$serverId/emojis',
            body: {
              'name': name.replaceAll(' ', '_'),
              'image': image.base64,
              'roles': roles.isNotEmpty ? roles : null,
            },
            option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));

    final raw = await _marshaller.serializers.channels.normalize(result);
    final emoji = await _marshaller.serializers.emojis.serialize({
      ...raw,
      'guild_id': serverId,
    });

    completer.complete(emoji);

    return completer.future;
  }

  @override
  Future<Emoji?> update(
      {required String id,
      required String serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final completer = Completer<Emoji>();

    final result = await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client
        .patch('/guilds/$serverId/emojis/$id',
            body: payload,
            option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));

    final raw = await _marshaller.serializers.emojis.normalize({
      ...result,
      'guild_id': serverId,
    });
    final emoji = await _marshaller.serializers.emojis.serialize(raw);

    completer.complete(emoji);
    return completer.future;
  }

  @override
  Future<void> delete(String serverId, String emojiId, {String? reason}) async {
    await _dataStore.requestBucket.run<Map<String, dynamic>>(() => _dataStore.client.delete(
        '/guilds/$serverId/emojis/$emojiId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)})));
  }
}
