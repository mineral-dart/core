import 'dart:async';

import 'package:mineral/src/domains/components/selects/contexts/private_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateTextSelectEventHandler = FutureOr Function(
    PrivateSelectContext, List<String>);

abstract class PrivateTextSelectEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverTextSelect;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateSelectContext ctx, List<String> values);
}
