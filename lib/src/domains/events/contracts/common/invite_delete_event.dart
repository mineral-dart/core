import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef InviteDeleteEventHandler = FutureOr<void> Function(
    String code, Channel channel);

abstract class InviteDeleteEvent extends BaseListenableEvent {
  @override
  Event get event => Event.inviteDelete;

  @override
  Function get handler => handle;

  FutureOr<void> handle(String code, Channel channel);
}
