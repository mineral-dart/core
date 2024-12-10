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
  Future<Sticker> getSticker(Snowflake serverId, Snowflake stickerId) async {
    final stickerCacheKey = _marshaller.cacheKey.sticker(serverId, stickerId);

    final Map<String, dynamic>? cachedRawSticker = await _marshaller.cache.get(stickerCacheKey);

    if (cachedRawSticker != null) {
      return _marshaller.serializers.sticker.serialize(cachedRawSticker);
    }

    final response = await _dataStore.client.get('/guilds/$serverId/stickers/$stickerId}');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final payload = await _marshaller.serializers.sticker.normalize(response.body);
    return _marshaller.serializers.sticker.serialize(payload);
  }
}
