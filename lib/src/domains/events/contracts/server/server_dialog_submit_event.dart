import 'dart:async';

import 'package:mineral/src/domains/components/dialog/contexts/server_dialog_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerDialogSubmitEventHandler<T> = FutureOr Function(
    ServerDialogContext ctx, T data);

abstract class ServerDialogSubmitEvent implements ListenableEvent {
  @override
  Event get event => Event.serverDialogSubmit;

  @override
  String? customId;

  FutureOr<void> handle(ServerDialogContext ctx);
}
