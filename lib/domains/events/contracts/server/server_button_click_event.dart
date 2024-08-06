import 'dart:async';

import 'package:mineral/domains/components/buttons/contexts/server_button_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerButtonClickEventHandler = FutureOr<void> Function(ServerButtonContext);

abstract class ServerButtonClickEvent implements ListenableEvent {
  @override
  Event get event => Event.serverButtonClick;

  FutureOr<void> handle(ServerButtonContext ctx);
}
