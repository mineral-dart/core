import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/audit_log/audit_log.dart';

final class MessageDeleteAuditLog extends AuditLog {
  final Snowflake messageId;
  final Snowflake? channelId;

  MessageDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.messageId,
    this.channelId,
  }) : super(AuditLogType.messageDelete, serverId, userId);
}

final class MessageBulkDeleteAuditLog extends AuditLog {
  final int count;
  final Snowflake? channelId;

  MessageBulkDeleteAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.count,
    this.channelId,
  }) : super(AuditLogType.messageBulkDelete, serverId, userId);
}

final class MessagePinAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake messageId;
  final Snowflake? channelId;

  MessagePinAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.messageId,
    this.channelId,
  }) : super(AuditLogType.messagePin, serverId, userId);

  Future<ServerMessage> resolveMessage({bool force = false}) async {
    final message = await _datastore.message.get<ServerMessage>(
      serverId.value,
      messageId.value,
      force,
    );
    return message!;
  }
}

final class MessageUnpinAuditLog extends AuditLog {
  DataStoreContract get _datastore => ioc.resolve<DataStoreContract>();

  final Snowflake messageId;
  final Snowflake? channelId;

  MessageUnpinAuditLog({
    required Snowflake serverId,
    required Snowflake userId,
    required this.messageId,
    this.channelId,
  }) : super(AuditLogType.messageUnpin, serverId, userId);

  Future<ServerMessage> resolveMessage({bool force = false}) async {
    final message = await _datastore.message.get<ServerMessage>(
      serverId.value,
      messageId.value,
      force,
    );
    return message!;
  }
}
