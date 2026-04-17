import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerStickersUpdateEventHandler = FutureOr<void> Function(
    Server, Map<Snowflake, Sticker>);

abstract class ServerStickersUpdateEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverStickersUpdate;

  @override
  Function get handler => handle;

  FutureOr<void> handle(Server server, Map<Snowflake, Sticker> stickers);
}
