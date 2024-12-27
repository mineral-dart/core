import 'dart:async';
import 'dart:io';

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
    final response = await _dataStore.client.get('/guilds/$serverId/channels');

    final rawEmojis = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => await Future.wait(List.from(response.body)
          .map((element) async => _marshaller.serializers.emojis.normalize(element))),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    };

    final emojis = await Future.wait(rawEmojis.map((element) async {
      final emoji = await _marshaller.serializers.emojis.serialize(element);
      await _marshaller.cache
          .put(_marshaller.cacheKey.serverEmoji(serverId, emoji.id!.value), element);

      return emoji;
    }));

    completer.complete(emojis.asMap().map((_, value) => MapEntry(value.id!, value)));
    return completer.future;
  }

  @override
  Future<Emoji?> get(String serverId, String emojiId, bool force) async {
    final completer = Completer<Emoji>();
    final String key = _marshaller.cacheKey.serverEmoji(serverId, emojiId);

    final cachedEmoji = await _marshaller.cache.get(key);
    if (!force && cachedEmoji != null) {
      final channel = await _marshaller.serializers.emojis.serialize(cachedEmoji);
      completer.complete(channel);

      return completer.future;
    }

    final response = await _dataStore.client.get('/guilds/$serverId/emojis/$emojiId');
    final emoji = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.emojis.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.emojis.serialize(emoji));

    return completer.future;
  }

  @override
  Future<Emoji> create(String serverId, String name, Image image, List<String> roles,
      {String? reason}) async {
    final completer = Completer<Emoji>();

    final response = await _dataStore.client.post('/guilds/$serverId/emojis',
        body: {
          'name': name.replaceAll(' ', '_'),
          'image': image.base64,
          'roles': roles.isNotEmpty ? roles : null,
        },
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final emoji = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.emojis.normalize({
          ...response.body,
          'guild_id': serverId,
        }),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.emojis.serialize(emoji));
    return completer.future;
  }

  @override
  Future<Emoji?> update(
      {required String id,
      required String serverId,
      required Map<String, dynamic> payload,
      required String? reason}) async {
    final completer = Completer<Emoji>();

    final response = await _dataStore.client.patch('/guilds/$serverId/emojis/$id',
        body: payload,
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    final emoji = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.emojis.normalize({
          ...response.body,
          'guild_id': serverId,
        }),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.emojis.serialize(emoji));
    return completer.future;
  }

  @override
  Future<void> delete(String serverId, String emojiId, {String? reason}) async {
    final response = await _dataStore.client.delete('/guilds/$serverId/emojis/$emojiId',
        option: HttpRequestOptionImpl(headers: {DiscordHeader.auditLogReason(reason)}));

    switch (response.statusCode) {
      case int() when status.isRateLimit(response.statusCode):
        throw HttpException(response.bodyString);
      case int() when status.isError(response.statusCode):
        throw HttpException(response.bodyString);
    }
  }
}
