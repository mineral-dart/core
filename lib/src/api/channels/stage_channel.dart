import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/managers/permission_overwrite_manager.dart';

class StageChannel extends GuildChannel {
  final int? _bitrate;
  final int? _userLimit;
  final String? _rtcRegion;

  StageChannel(
    this._bitrate,
    this._userLimit,
    this._rtcRegion,
    super.guildId,
    super.parentId,
    super.label,
    super.type,
    super.position,
    super.flags,
    super.permissions,
    super.id
  );

  /// Get bitrate of this
  int? get bitrate => _bitrate;

  /// Get [User] max on this
  int? get userLimit => _userLimit;

  /// Get region of this
  String? get rtcRegion => _rtcRegion;

  factory StageChannel.fromPayload(dynamic payload) {
    final permissionOverwriteManager = PermissionOverwriteManager();
    for (dynamic element in payload['permission_overwrites']) {
      final PermissionOverwrite overwrite = PermissionOverwrite.from(payload: element);
      permissionOverwriteManager.cache.putIfAbsent(overwrite.id, () => overwrite);
    }

    return StageChannel(
      payload['bitrate'],
      payload['user_limit'],
      payload['rtc_region'],
      payload['guild_id'],
      payload['parent_id'],
      payload['name'],
      payload['type'],
      payload['position'],
      payload['flags'],
      permissionOverwriteManager,
      payload['id']
    );
  }
}
