import 'dart:async';

import 'package:mineral/src/domains/components/selects/contexts/private_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateTextSelectEventHandler = FutureOr Function(
    PrivateSelectContext, List<String>);

abstract class PrivateTextSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.serverTextSelect;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateSelectContext ctx, List<String> values);
}
