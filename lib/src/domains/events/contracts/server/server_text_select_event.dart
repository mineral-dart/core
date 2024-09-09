import 'dart:async';

import 'package:mineral/src/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerTextSelectEventHandler = FutureOr Function(
    ServerSelectContext, List<String>);

abstract class ServerTextSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.serverTextSelect;

  @override
  String? customId;

  FutureOr<void> handle(ServerSelectContext ctx, List<String> values);
}
