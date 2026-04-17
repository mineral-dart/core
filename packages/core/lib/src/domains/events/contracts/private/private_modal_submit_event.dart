import 'dart:async';

import 'package:mineral/src/domains/components/modal/contexts/private_modal_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateModalSubmitEventHandler = FutureOr<void> Function(
    PrivateModalContext);

abstract class PrivateModalSubmitEvent extends BaseListenableEvent {
  @override
  Event get event => Event.privateModalSubmit;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateModalContext ctx);
}
