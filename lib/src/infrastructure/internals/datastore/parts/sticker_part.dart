import 'dart:async';

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

    final result = await _dataStore.requestBucket
        .run<List>(() => _dataStore.client.get('/guilds/$serverId/stickers'));

    final stickers = await result.map((element) async {
      final raw = await _marshaller.serializers.sticker.normalize(element);
      return _marshaller.serializers.sticker.serialize(raw);
    }).wait;

    completer.complete(stickers.asMap().map((_, value) => MapEntry(value.id, value)));
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

    final result = await _dataStore.requestBucket.run<Map<String, dynamic>>(
        () => _dataStore.client.get('/guilds/$serverId/stickers/$stickerId'));

    final raw = await _marshaller.serializers.sticker.normalize(result);
    final sticker = await _marshaller.serializers.sticker.serialize(raw);

    completer.complete(sticker);
    return completer.future;
  }

  @override
  Future<void> delete(String serverId, String stickerId) async {
    await _dataStore.requestBucket.run<Map<String, dynamic>>(
        () => _dataStore.client.delete('/guilds/$serverId/stickers/$stickerId'));
  }
}
