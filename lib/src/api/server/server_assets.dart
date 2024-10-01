import 'dart:io';

import 'package:mineral/container.dart';
import 'package:mineral/src/api/common/image_asset.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/managers/emoji_manager.dart';
import 'package:mineral/src/api/server/managers/sticker_manager.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/server_part.dart';

final class ServerAsset {
  ServerPart get _serverPart => ioc.resolve<DataStoreContract>().server;

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


  Future<void> setIcon(File icon, {String? reason}) async {
    final iconAsset = ImageAsset.makeAsset(icon);
    await _serverPart.updateServer(serverId, {'icon': iconAsset.makeUrl()}, reason);
  }

  Future<void> setBanner(File banner, {String? reason}) async {
    final bannerAsset = ImageAsset.makeAsset(banner);
    await _serverPart.updateServer(serverId, {'banner': bannerAsset.makeUrl()}, reason);
  }

  Future<void> setSplash(File splash, {String? reason}) async {
    final splashAsset = ImageAsset.makeAsset(splash);
    await _serverPart.updateServer(serverId, {'splash': splashAsset.makeUrl()}, reason);
  }

  Future<void> setDiscoverySplash(File discoverySplash, {String? reason}) async {
    final discoverySplashAsset = ImageAsset.makeAsset(discoverySplash);
    await _serverPart.updateServer(serverId, {'discovery_splash': discoverySplashAsset.makeUrl()}, reason);
  }
}
