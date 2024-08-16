import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/api/server/managers/emoji_manager.dart';
import 'package:mineral/api/server/managers/sticker_manager.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class ServerAssetsSerializer implements SerializerContract<ServerAsset> {
  final MarshallerContract _marshaller;

  ServerAssetsSerializer(this._marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final cacheKey = _marshaller.cacheKey.serverAssets(json['id']);

    await List.from(json['roles']).map((element) async {
      return _marshaller.serializers.role.normalize({...element, 'server_id': json['id']});
    }).wait;

    await List.from(json['emojis']).map((element) async {
      return _marshaller.serializers.emojis.normalize({...element, 'server_id': json['id']});
    }).wait;

    final payload = {
      'icon': json['icon'],
      'icon_hash': json['icon_hash'],
      'splash': json['splash'],
      'discovery_splash': json['discovery_splash'],
      'banner': json['banner'],
      'roles': List.from(json['roles'])
          .map((element) => _marshaller.cacheKey.serverRole(json['id'], element['id']))
          .toList(),
      'emojis': List.from(json['emojis'])
          .map((element) => _marshaller.cacheKey.serverEmoji(json['id'], element['id']))
          .toList(),
    };

    _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  ServerAsset serialize(Map<String, dynamic> json) => _serialize(json);

  ServerAsset _serialize(Map<String, dynamic> json) {
    final guildRoles = List<Role>.from(json['guildRoles']);

    return ServerAsset(
      emojis: EmojiManager.fromJson(_marshaller, roles: guildRoles, payload: json['emojis']),
      stickers: StickerManager.fromJson(_marshaller, json['stickers']),
      icon: Helper.createOrNull(
          field: json['icon'], fn: () => ImageAsset(['icons', json['id']], json['icon'])),
      splash: Helper.createOrNull(
          field: json['splash'], fn: () => ImageAsset(['splashes', json['id']], json['splash'])),
      banner: Helper.createOrNull(
          field: json['banner'], fn: () => ImageAsset(['banners', json['id']], json['banner'])),
      discoverySplash: Helper.createOrNull(
          field: json['discovery_splash'],
          fn: () => ImageAsset(['discovery-splashes', json['id']], json['discovery_splash'])),
    );
  }

  @override
  Map<String, dynamic> deserialize(ServerAsset object) {
    final emojis = object.emojis.list.values.map(_marshaller.serializers.emojis.deserialize);
    final stickers = object.stickers.list.values.map(_marshaller.serializers.sticker.deserialize);

    return {
      'emojis': emojis.toList(),
      'stickers': stickers.toList(),
      'icon': object.icon?.hash,
      'splash': object.splash?.hash,
      'banner': object.banner?.hash,
      'discovery_splash': object.discoverySplash?.hash,
    };
  }
}
