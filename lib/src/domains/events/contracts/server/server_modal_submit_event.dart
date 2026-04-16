import 'dart:async';

import 'package:mineral/src/domains/components/modal/contexts/server_modal_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerModalSubmitEventHandler<T> = FutureOr Function(
    ServerModalContext ctx, T data);

abstract class ServerModalSubmitEvent<T> extends BaseListenableEvent {
  @override
  Event get event => Event.serverModalSubmit;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerModalContext ctx, T data);
}
