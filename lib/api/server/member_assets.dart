import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/api/common/snowflake.dart';

final class MemberAssets {
  final ImageAsset? avatar;
  final ImageAsset? avatarDecoration;
  final ImageAsset? banner;
  final Snowflake memberId;
  final Snowflake serverId;

  MemberAssets({
    required this.avatar,
    required this.avatarDecoration,
    required this.banner,
    required this.memberId,
    required this.serverId,
  });
}
