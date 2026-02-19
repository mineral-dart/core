import 'dart:async';

import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/listenable_event.dart';

typedef ServerChannelSelectEventHandler = FutureOr Function(
    ServerSelectContext ctx, List<ServerChannel> channels);

abstract class ServerChannelSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.serverChannelSelect;

  @override
  String? customId;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerSelectContext ctx, List<ServerChannel> channels);
}
