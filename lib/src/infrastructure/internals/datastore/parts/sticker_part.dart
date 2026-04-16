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
    final req = Request.json(endpoint: '/guilds/$serverId/stickers');
    final result = await _dataStore.requestBucket
        .query<List<Map<String, dynamic>>>(req)
        .run(_dataStore.client.get);

    final stickers = await result.map((element) async {
      final raw = await _marshaller.serializers.sticker.normalize(element);
      return _marshaller.serializers.sticker.serialize(raw);
    }).wait;

    return stickers.asMap().map((_, value) => MapEntry(value.id, value));
  }

  @override
  Future<Sticker?> get(Object serverId, Object stickerId, bool force) async {
    final String key = _marshaller.cacheKey.sticker(serverId, stickerId);

    final cachedSticker = await _marshaller.cache?.get(key);
    if (!force && cachedSticker != null) {
      final sticker =
          await _marshaller.serializers.sticker.serialize(cachedSticker);

      return sticker;
    }

    final req = Request.json(endpoint: '/guilds/$serverId/stickers/$stickerId');
    final result = await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.get);

    final raw = await _marshaller.serializers.sticker.normalize(result);
    final sticker = await _marshaller.serializers.sticker.serialize(raw);

    return sticker;
  }

  @override
  Future<void> delete(Object serverId, Object stickerId) async {
    final req = Request.json(endpoint: '/guilds/$serverId/stickers/$stickerId');
    await _dataStore.requestBucket
        .query<Map<String, dynamic>>(req)
        .run(_dataStore.client.delete);
  }
}
