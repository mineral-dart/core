import 'dart:async';

import 'package:mineral/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerTextSelectEventHandler = FutureOr Function(ServerSelectContext, List<String>);

abstract class ServerTextSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.serverTextSelect;

  String? get customId;

  FutureOr<void> handle(ServerSelectContext ctx, List<String> values);
}
