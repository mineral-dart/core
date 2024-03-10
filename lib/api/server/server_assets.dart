import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/api/server/managers/emoji_manager.dart';
import 'package:mineral/api/server/managers/role_manager.dart';
import 'package:mineral/api/server/managers/sticker_manager.dart';
import 'package:mineral/domains/shared/helper.dart';

final class ServerAsset {
  final EmojiManager emojis;
  final StickerManager stickers;
  final ImageAsset? icon;
  final ImageAsset? splash;
  final ImageAsset? banner;
  final ImageAsset? discoverySplash;

  ServerAsset({
    required this.emojis,
    required this.stickers,
    required this.icon,
    required this.splash,
    required this.banner,
    required this.discoverySplash,
  });

  factory ServerAsset.fromJson(RoleManager roles, Map<String, dynamic> json) {
    return ServerAsset(
      emojis: EmojiManager.fromJson(roles: roles, json: json['emojis']),
      stickers: StickerManager.fromJson(json['stickers']),
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
}
