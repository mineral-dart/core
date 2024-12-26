import 'package:mineral/src/api/common/image_asset.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/managers/emoji_manager.dart';
import 'package:mineral/src/api/server/managers/sticker_manager.dart';
import 'package:mineral/src/api/server/server_assets.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/domains/contracts/marshaller/marshaller.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerAssetsSerializer implements SerializerContract<ServerAsset> {
  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final cacheKey = _marshaller.cacheKey.serverAssets(json['id']);

    final payload = {
      'icon': json['icon'],
      'icon_hash': json['icon_hash'],
      'splash': json['splash'],
      'discovery_splash': json['discovery_splash'],
      'banner': json['banner'],
      'server_id': json['id'],
    };

    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<ServerAsset> serialize(Map<String, dynamic> json) async {
    return ServerAsset(Snowflake(json['server_id']),
      emojis: EmojiManager(json['server_id']),
      stickers: StickerManager(json['server_id']),
      icon: Helper.createOrNull(
          field: json['icon'],
          fn: () => ImageAsset(['icons', json['server_id']], json['icon'])),
      splash: Helper.createOrNull(
          field: json['splash'],
          fn: () =>
              ImageAsset(['splashes', json['server_id']], json['splash'])),
      banner: Helper.createOrNull(
          field: json['banner'],
          fn: () => ImageAsset(['banners', json['server_id']], json['banner'])),
      discoverySplash: Helper.createOrNull(
          field: json['discovery_splash'],
          fn: () => ImageAsset(
              ['discovery-splashes', json['id']], json['discovery_splash'])),
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(ServerAsset object) async {
    return {
      'icon': object.icon?.hash,
      'splash': object.splash?.hash,
      'banner': object.banner?.hash,
      'discovery_splash': object.discoverySplash?.hash,
      'server_id': object.serverId.value,
    };
  }
}
