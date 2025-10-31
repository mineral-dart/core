import 'dart:async';

import 'package:mineral/src/domains/components/modal/contexts/server_modal_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerModalSubmitEventHandler<T> = FutureOr Function(
  ServerModalContext ctx,
  T data,
);

abstract class ServerModalSubmitEvent<T> implements ListenableEvent {
  @override
  Event get event => Event.serverModalSubmit;

  @override
  String? customId;

  FutureOr<void> handle(
    ServerModalContext ctx,
    T data,
  );
}
