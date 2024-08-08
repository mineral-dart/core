import 'dart:async';

import 'package:mineral/domains/components/dialog/contexts/server_dialog_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerDialogSubmitEventHandler = Function;

abstract class ServerDialogSubmitEvent implements ListenableEvent {
  @override
  Event get event => Event.serverDialogSubmit;

  FutureOr<void> handle(ServerDialogContext ctx);
}
