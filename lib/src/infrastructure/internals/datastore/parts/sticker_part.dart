import 'dart:async';
import 'dart:io';

import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/sticker.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store_part.dart';
import 'package:mineral/src/infrastructure/kernel/kernel.dart';
import 'package:mineral/src/infrastructure/services/http/http_client_status.dart';

final class StickerPart implements DataStorePart {
  final KernelContract _kernel;

  HttpClientStatus get status => _kernel.dataStore.client.status;

  StickerPart(this._kernel);

  Future<Sticker> getSticker(Snowflake serverId, Snowflake stickerId) async {
    final stickerCacheKey =
        _kernel.marshaller.cacheKey.sticker(serverId, stickerId);

    final Map<String, dynamic>? cachedRawSticker =
        await _kernel.marshaller.cache.get(stickerCacheKey);

    if (cachedRawSticker != null) {
      return _kernel.marshaller.serializers.sticker.serialize(cachedRawSticker);
    }

    final response = await _kernel.dataStore.client
        .get('/guilds/$serverId/stickers/$stickerId}');
    if (status.isError(response.statusCode)) {
      throw HttpException(response.body);
    }

    final payload =
        await _kernel.marshaller.serializers.sticker.normalize(response.body);
    return _kernel.marshaller.serializers.sticker.serialize(payload);
  }
}
