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

  /// Set the server's icon.
  ///
  /// ```dart
  /// await server.assets.setIcon(File('icon.png'), reason: 'Testing');
  /// ```
  Future<void> setIcon(File icon, {String? reason}) async {
    final iconAsset = ImageAsset.makeAsset(icon);
    await _serverPart.updateServer(serverId, {'icon': iconAsset.makeUrl()}, reason);
  }

  /// Set the server's banner.
  ///
  /// ```dart
  /// await server.assets.setBanner(File('banner.png'), reason: 'Testing');
  /// ```
  Future<void> setBanner(File banner, {String? reason}) async {
    final bannerAsset = ImageAsset.makeAsset(banner);
    await _serverPart.updateServer(serverId, {'banner': bannerAsset.makeUrl()}, reason);
  }

  /// Set the server's splash.
  ///
  /// ```dart
  /// await server.assets.setSplash(File('splash.png'), reason: 'Testing');
  /// ```
  Future<void> setSplash(File splash, {String? reason}) async {
    final splashAsset = ImageAsset.makeAsset(splash);
    await _serverPart.updateServer(serverId, {'splash': splashAsset.makeUrl()}, reason);
  }

  /// Set the server's discovery splash.
  ///
  /// ```dart
  /// await server.assets.setDiscoverySplash(File('discovery_splash.png'), reason: 'Testing');
  /// ```
  Future<void> setDiscoverySplash(File discoverySplash, {String? reason}) async {
    final discoverySplashAsset = ImageAsset.makeAsset(discoverySplash);
    await _serverPart.updateServer(serverId, {'discovery_splash': discoverySplashAsset.makeUrl()}, reason);
  }
}
