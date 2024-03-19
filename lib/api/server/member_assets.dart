import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/domains/shared/helper.dart';

final class MemberAssets {
  final ImageAsset? avatar;
  final ImageAsset? avatarDecoration;
  final ImageAsset? banner;

  MemberAssets({
    required this.avatar,
    required this.avatarDecoration,
    required this.banner,
  });

  factory MemberAssets.fromJson(Map<String, dynamic> json) {
    return MemberAssets(
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
