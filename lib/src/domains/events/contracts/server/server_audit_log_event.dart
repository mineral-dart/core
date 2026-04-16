import 'dart:async';

import 'package:mineral/src/api/server/audit_log/audit_log.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerAuditLogEventHandler = FutureOr<void> Function(AuditLog);

abstract class ServerAuditLogEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverAuditLog;

  @override
  Function get handler => handle;

  FutureOr<void> handle(AuditLog audit);
}
