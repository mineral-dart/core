import 'package:mineral/api/common/image_asset.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/private/user_assets.dart';
import 'package:mineral/api/server/member_assets.dart';
import 'package:mineral/infrastructure/commons/helper.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class UserAssetsSerializer implements SerializerContract<UserAssets> {
  final MarshallerContract _marshaller;

  UserAssetsSerializer(this._marshaller);

  @override
  Future<Map<String, dynamic>> normalize(Map<String, dynamic> json) async {
    final payload = {
      'user_id': json['user_id'],
      'avatar': json['avatar'],
      'avatar_decoration': json['avatar_decoration_data']?['sku_id'],
      'banner': json['banner'],
    };

    final cacheKey = _marshaller.cacheKey.userAssets(json['user_id']);
    await _marshaller.cache.put(cacheKey, payload);

    return payload;
  }

  @override
  Future<UserAssets> serialize(Map<String, dynamic> json) async {
    return UserAssets(
      avatar: Helper.createOrNull(
          field: json['avatar'],
          fn: () => ImageAsset(['avatars', json['member_id']], json['avatar'])),
      avatarDecoration: Helper.createOrNull(
          field: json['avatar_decoration'],
          fn: () =>
              ImageAsset(['avatar-decorations', json['member_id']], json['avatar_decoration'])),
      banner: Helper.createOrNull(
          field: json['banner'],
          fn: () => ImageAsset(['banners', json['member_id']], json['banner'])),
      userId: Snowflake(json['user_id']),
    );
  }

  @override
  Map<String, dynamic> deserialize(UserAssets assets) {
    return {
      'user_id': assets.userId.value,
      'avatar': assets.avatar?.hash,
      'avatar_decoration': assets.avatarDecoration?.hash,
      'banner': assets.banner?.hash,
    };
  }
}
