import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/audit_log/actions/sticker.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> stickerCreateAuditLogHandler(Map<String, dynamic> json) async {
  final datastore = ioc.resolve<DataStoreContract>();
  final sticker = await datastore.sticker.get(
    json['guild_id'],
    json['target_id'],
    false,
  );

  return StickerCreateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    stickerId: Snowflake.parse(json['target_id']),
    sticker: sticker!,
  );
}

Future<AuditLog> stickerUpdateAuditLogHandler(Map<String, dynamic> json) async {
  final datastore = ioc.resolve<DataStoreContract>();
  final sticker = await datastore.sticker.get(
    json['guild_id'],
    json['target_id'],
    false,
  );

  return StickerUpdateAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    stickerId: Snowflake.parse(json['target_id']),
    changes: List<Map<String, dynamic>>.from(json['changes'])
        .map(Change.fromJson)
        .toList(),
    sticker: sticker!,
  );
}

Future<AuditLog> stickerDeleteAuditLogHandler(Map<String, dynamic> json) async {
  return StickerDeleteAuditLog(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    stickerId: Snowflake.parse(json['target_id']),
  );
}
