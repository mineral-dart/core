import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/managers/emoji_manager.dart';
import 'package:mineral/api/server/managers/sticker_manager.dart';

final class ServerAsset {
  final Snowflake serverId;
  final ImageAsset? icon;
  final ImageAsset? splash;
  final ImageAsset? banner;
  final ImageAsset? discoverySplash;
  EmojiManager emojis;
  StickerManager stickers;

  ServerAsset({
    required this.serverId,
    required this.emojis,
    required this.stickers,
    required this.icon,
    required this.splash,
    required this.banner,
    required this.discoverySplash,
  });
}
