import 'dart:async';

import 'package:mineral/domains/components/buttons/contexts/private_button_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateButtonClickEventHandler = FutureOr<void> Function(PrivateButtonContext);

abstract class PrivateButtonClickEvent implements ListenableEvent {
  @override
  Event get event => Event.privateButtonClick;

  @override
  String? customId;

  FutureOr<void> handle(PrivateButtonContext ctx);
}
