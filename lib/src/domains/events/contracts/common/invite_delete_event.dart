import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef InviteDeleteEventHandler = FutureOr<void> Function(
  String code,
  Channel channel,
);

abstract class InviteDeleteEvent implements ListenableEvent {
  @override
  Event get event => Event.inviteDelete;

  @override
  String? customId;

  FutureOr<void> handle(String code, Channel channel);
}
