import 'dart:async';

import 'package:mineral/src/domains/components/modal/contexts/private_modal_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateModalSubmitEventHandler = FutureOr<void> Function(
    PrivateModalContext);

abstract class PrivateModalSubmitEvent implements ListenableEvent {
  @override
  Event get event => Event.privateModalSubmit;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateModalContext ctx);
}
