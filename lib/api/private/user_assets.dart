import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/infrastructure/commons/helper.dart';

final class UserAssets {
  final ImageAsset? avatar;
  final ImageAsset? avatarDecoration;
  final ImageAsset? banner;

  UserAssets({
    required this.avatar,
    required this.avatarDecoration,
    required this.banner,
  });

  factory UserAssets.fromJson(Map<String, dynamic> json) {
    return UserAssets(
      avatar: Helper.createOrNull(
          field: json['avatar'], fn: () => ImageAsset(['avatars', json['id']], json['avatar'])),
      avatarDecoration: Helper.createOrNull(
          field: json['avatar_decoration_data']?['sku_id'],
          fn: () => ImageAsset(['avatar-decorations', json['id']], json['avatar_decoration_data']['sku_id'])),
      banner: Helper.createOrNull(
          field: json['banner'], fn: () => ImageAsset(['banners', json['id']], json['banner'])),
    );
  }
}
