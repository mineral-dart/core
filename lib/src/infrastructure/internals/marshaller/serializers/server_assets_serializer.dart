import 'package:mineral/src/api/common/image_asset.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/managers/emoji_manager.dart';
import 'package:mineral/src/api/server/managers/sticker_manager.dart';
import 'package:mineral/src/api/server/server_assets.dart';
import 'package:mineral/src/infrastructure/commons/helper.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerAssetsSerializer implements SerializerContract<ServerAsset> {
  final MarshallerContract _marshaller;

  ServerAssetsSerializer(this._marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final cacheKey = _marshaller.cacheKey.serverAssets(json['id']);

    await List.from(json['roles']).map((element) async {
      return _marshaller.serializers.role
          .normalize({...element, 'server_id': json['id']});
    }).wait;

    await List.from(json['emojis']).map((element) async {
      return _marshaller.serializers.emojis
          .normalize({...element, 'server_id': json['id']});
    }).wait;

    await List.from(json['stickers']).map((element) async {
      return _marshaller.serializers.sticker
          .normalize({...element, 'server_id': json['id']});
    }).wait;

    final payload = {
      'icon': json['icon'],
      'icon_hash': json['icon_hash'],
      'splash': json['splash'],
      'discovery_splash': json['discovery_splash'],
      'banner': json['banner'],
      'stickers': List.from(json['stickers'])
          .map((element) =>
              _marshaller.cacheKey.sticker(json['id'], element['id']))
          .toList(),
      'roles': List.from(json['roles'])
          .map((element) =>
              _marshaller.cacheKey.serverRole(json['id'], element['id']))
          .toList(),
      'emojis': List.from(json['emojis'])
          .map((element) =>
              _marshaller.cacheKey.serverEmoji(json['id'], element['id']))
          .toList(),
      'server_id': json['id'],
    };

    _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<ServerAsset> serialize(Map<String, dynamic> json) async {
    final rawRoles = await _marshaller.cache.getMany(json['roles']);
    final roles = await rawRoles.nonNulls.map((element) async {
      return _marshaller.serializers.role.serialize(element);
    }).wait;

    final rawEmojis = await _marshaller.cache.getMany(json['emojis']);
    final emojis = await rawEmojis.nonNulls.map((id) async {
      return _marshaller.serializers.emojis.serialize(id);
    }).wait;

    final rawStickers = await _marshaller.cache.getMany(json['stickers']);
    final stickers = await rawStickers.nonNulls.map((id) async {
      return _marshaller.serializers.sticker.serialize(id);
    }).wait;

    return ServerAsset(
      emojis: EmojiManager.fromList(roles, emojis),
      stickers: StickerManager.fromList(stickers),
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
      serverId: Snowflake(json['server_id']),
    );
  }

  @override
  Future<Map<String, dynamic>> deserialize(ServerAsset object) async {
    final emojis = await Future.wait(object.emojis.list.values.map(
        (element) async =>
            _marshaller.serializers.emojis.deserialize(element)));
    final stickers = await Future.wait(object.stickers.list.values.map(
        (element) async =>
            _marshaller.serializers.sticker.deserialize(element)));

    return {
      'emojis': emojis.map((element) => element['id']).toList(),
      'stickers': stickers.map((element) => element['id']).toList(),
      'icon': object.icon?.hash,
      'splash': object.splash?.hash,
      'banner': object.banner?.hash,
      'discovery_splash': object.discoverySplash?.hash,
      'server_id': object.serverId.value,
    };
  }
}
