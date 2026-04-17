import 'dart:async';

import 'package:mineral/src/domains/components/selects/contexts/private_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateMentionableSelectEventHandler = FutureOr<void> Function(
    PrivateSelectContext ctx, List<dynamic> mentionables);

abstract class PrivateMentionableSelectEvent extends BaseListenableEvent {
  @override
  Event get event => Event.privateMentionableSelect;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateSelectContext ctx, List<dynamic> mentionables);
}
