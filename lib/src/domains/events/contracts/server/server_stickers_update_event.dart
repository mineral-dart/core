import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerStickersUpdateEventHandler = FutureOr<void> Function(Server, Map<Snowflake, Sticker>);

abstract class ServerStickersUpdateEvent implements ListenableEvent {
  @override
  Event get event => Event.serverStickersUpdate;

  @override
  String? customId;

  FutureOr<void> handle(Server server, Map<Snowflake, Sticker> stickers);
}
