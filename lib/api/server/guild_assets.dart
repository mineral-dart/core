import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/domains/shared/utils.dart';

final class GuildAsset {
  final ImageAsset? icon;
  final ImageAsset? splash;
  final ImageAsset? banner;
  final ImageAsset? discoverySplash;

  GuildAsset({
    this.icon,
    this.splash,
    this.banner,
    this.discoverySplash,
  });

  factory GuildAsset.fromJson(Map<String, dynamic> json) {
    return GuildAsset(
      icon: createOrNull(
          field: json['icon'], fn: () => ImageAsset(['icons', json['id']], json['icon'])),
      splash: createOrNull(
          field: json['splash'], fn: () => ImageAsset(['splashes', json['id']], json['splash'])),
      banner: createOrNull(
          field: json['banner'], fn: () => ImageAsset(['banners', json['id']], json['banner'])),
      discoverySplash: createOrNull(
          field: json['discovery_splash'],
          fn: () => ImageAsset(['discovery-splashes', json['id']], json['discovery_splash'])),
    );
  }
}
