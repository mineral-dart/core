import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

abstract interface class AuditLogChange<B, A> {
  B get before;

  A get after;
}

abstract class AuditLogActionContract {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  AuditLogType type;
  Snowflake serverId;
  Snowflake? userId;

  AuditLogActionContract(this.type, this.serverId, this.userId);

  Future<Server> resolveServer() => _datastore.server.get(serverId.value, true);
}

final class ServerUpdateAuditLogAction extends AuditLog {
  ServerUpdateAuditLogAction(
      {required Snowflake serverId, required Snowflake userId})
      : super(AuditLogType.guildUpdate, serverId, userId);
}

final class UnknownAuditLogAction extends AuditLog {
  UnknownAuditLogAction(
      {required Snowflake serverId, required Snowflake userId})
      : super(AuditLogType.guildUpdate, serverId, userId);

  factory UnknownAuditLogAction.fromJson(Map<String, dynamic> json) =>
      UnknownAuditLogAction(
          serverId: Snowflake.parse(json['guild_id']),
          userId: Snowflake.parse(json['user_id']));
}
