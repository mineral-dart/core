import 'package:mineral/src/api/common/image_asset.dart';
import 'package:mineral/src/api/common/snowflake.dart';

final class UserAssets {
  final ImageAsset? avatar;
  final ImageAsset? avatarDecoration;
  final ImageAsset? banner;

  UserAssets({
    required this.avatar,
    required this.avatarDecoration,
    required this.banner,
  });
}
