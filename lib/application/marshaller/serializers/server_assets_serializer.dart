import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/api/server/managers/emoji_manager.dart';
import 'package:mineral/api/server/managers/sticker_manager.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/application/marshaller/marshaller.dart';
import 'package:mineral/application/marshaller/types/serializer.dart';
import 'package:mineral/domains/shared/helper.dart';

final class ServerAssetsSerializer implements SerializerContract<ServerAsset> {
  final MarshallerContract _marshaller;

  ServerAssetsSerializer(this._marshaller);

  @override
  ServerAsset serialize(Map<String, dynamic> json) {
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
