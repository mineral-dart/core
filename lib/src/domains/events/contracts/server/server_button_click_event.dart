import 'dart:async';

import 'package:mineral/src/domains/components/buttons/contexts/server_button_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerButtonClickEventHandler = FutureOr<void> Function(
    ServerButtonContext);

abstract class ServerButtonClickEvent implements ListenableEvent {
  @override
  Event get event => Event.serverButtonClick;

  @override
  String? customId;

  FutureOr<void> handle(ServerButtonContext ctx);
}
