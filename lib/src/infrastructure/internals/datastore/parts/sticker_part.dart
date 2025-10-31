import 'dart:async';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/sticker.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';

final class StickerPart implements StickerPartContract {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  HttpClientStatus get status => _dataStore.client.status;

  @override
  Future<Map<Snowflake, Sticker>> fetch(Object serverId, bool force) async {
    final completer = Completer<Map<Snowflake, Sticker>>();

    final req = Request.json(endpoint: '/guilds/$serverId/stickers');
    final result = await _dataStore.requestBucket
        .query<List<Map<String, dynamic>>>(req)
        .run(_dataStore.client.get);

    final stickers = await result.map((element) async {
      final raw = await _marshaller.serializers.sticker.normalize(element);
      return _marshaller.serializers.sticker.serialize(raw);
    }).wait;

    completer.complete(
      stickers.asMap().map((_, value) => MapEntry(value.id, value)),
    );
    return completer.future;
  }

  @override
  Future<Sticker?> get(Object serverId, Object stickerId, bool force) async {
    final completer = Completer<Sticker>();
    final String key = _marshaller.cacheKey.sticker(serverId, stickerId);

    final cachedSticker = await _marshaller.cache?.get(key);
    if (!force && cachedSticker != null) {
      final sticker = await _marshaller.serializers.sticker.serialize(
        cachedSticker,
      );

      completer.complete(sticker);
      return completer.future;
    }

    final req = Request.json(endpoint: '/guilds/$serverId/stickers/$stickerId');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.sticker.normalize(result);
    final sticker = await _marshaller.serializers.sticker.serialize(raw);

    completer.complete(sticker);
    return completer.future;
  }

  @override
  Future<void> delete(Object serverId, Object stickerId) async {
    final req = Request.json(endpoint: '/guilds/$serverId/stickers/$stickerId');
    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }
}
