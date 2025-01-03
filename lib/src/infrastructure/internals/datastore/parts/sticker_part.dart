import 'dart:async';
import 'dart:io';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/sticker.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';

final class StickerPart implements StickerPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, Sticker>> fetch(String serverId, bool force) async {
    final completer = Completer<Map<Snowflake, Sticker>>();
    final response = await _dataStore.client.get('/guilds/$serverId/stickers');

    final rawEmojis = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) => await Future.wait(List.from(response.body)
          .map((element) async => _marshaller.serializers.sticker.normalize(element))),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}'),
    };

    final emojis = await Future.wait(rawEmojis.map((element) async {
      return  _marshaller.serializers.sticker.serialize(element);
    }));

    completer.complete(emojis.asMap().map((_, value) => MapEntry(value.id!, value)));
    return completer.future;
  }

  @override
  Future<Sticker?> get(String serverId, String stickerId, bool force) async {
    final completer = Completer<Sticker>();
    final String key = _marshaller.cacheKey.sticker(serverId, stickerId);

    final cachedSticker = await _marshaller.cache?.get(key);
    if (!force && cachedSticker != null) {
      final sticker = await _marshaller.serializers.sticker.serialize(cachedSticker);
      completer.complete(sticker);

      return completer.future;
    }

    final response = await _dataStore.client.get('/guilds/$serverId/stickers/$stickerId');
    final sticker = switch (response.statusCode) {
      int() when status.isSuccess(response.statusCode) =>
        await _marshaller.serializers.sticker.normalize(response.body),
      int() when status.isRateLimit(response.statusCode) =>
        throw HttpException(response.bodyString),
      int() when status.isError(response.statusCode) => throw HttpException(response.bodyString),
      _ => throw Exception('Unknown status code: ${response.statusCode} ${response.bodyString}')
    };

    completer.complete(await _marshaller.serializers.sticker.serialize(sticker));

    return completer.future;
  }
}
