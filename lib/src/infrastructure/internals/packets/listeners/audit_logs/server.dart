import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

Future<AuditLog> serverUpdateAuditLogHandler(Map<String, dynamic> json) async {
  final datastore = ioc.resolve<DataStoreContract>();
  final server = await datastore.server.get(json['guild_id'], true);

  return ServerUpdateAuditLogAction(
    serverId: Snowflake.parse(json['guild_id']),
    userId: Snowflake.parse(json['user_id']),
    server: server,
    changes: List<Change>.from(json['changes'].map((e) => Change.fromJson(e))),
  );
}
