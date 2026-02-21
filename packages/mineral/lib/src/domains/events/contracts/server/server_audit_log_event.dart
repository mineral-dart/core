import 'dart:async';

import 'package:mineral/src/api/server/audit_log/audit_log.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerAuditLogEventHandler = FutureOr<void> Function(AuditLog);

abstract class ServerAuditLogEvent implements ListenableEvent {
  @override
  Event get event => Event.serverAuditLog;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(AuditLog audit);
}
