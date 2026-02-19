import 'dart:async';

import 'package:mineral/src/domains/components/selects/contexts/private_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef PrivateMentionableSelectEventHandler = FutureOr<void> Function(
    PrivateSelectContext ctx, List<dynamic> mentionables);

abstract class PrivateMentionableSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.privateMentionableSelect;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateSelectContext ctx, List<dynamic> mentionables);
}
