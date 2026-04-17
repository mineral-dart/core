import 'dart:async';

import 'package:mineral/src/domains/components/buttons/contexts/server_button_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerButtonClickEventHandler = FutureOr<void> Function(
    ServerButtonContext);

abstract class ServerButtonClickEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverButtonClick;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerButtonContext ctx);
}
