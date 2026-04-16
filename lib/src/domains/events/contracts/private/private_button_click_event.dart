import 'dart:async';

import 'package:mineral/src/domains/components/buttons/contexts/private_button_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateButtonClickEventHandler = FutureOr<void> Function(
    PrivateButtonContext);

abstract class PrivateButtonClickEvent extends BaseListenableEvent {
  @override
  Event get event => Event.privateButtonClick;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateButtonContext ctx);
}
