import 'dart:async';

import 'package:mineral/src/domains/components/dialog/contexts/private_dialog_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateDialogSubmitEventHandler = FutureOr<void> Function(
    PrivateDialogContext);

abstract class PrivateDialogSubmitEvent implements ListenableEvent {
  @override
  Event get event => Event.privateDialogSubmit;

  @override
  String? customId;

  FutureOr<void> handle(PrivateDialogContext ctx);
}
