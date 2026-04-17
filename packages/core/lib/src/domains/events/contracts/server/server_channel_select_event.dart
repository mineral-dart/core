import 'dart:async';

import 'package:mineral/src/api/server/channels/server_channel.dart';
import 'package:mineral/src/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerChannelSelectEventHandler = FutureOr Function(
    ServerSelectContext ctx, List<ServerChannel> channels);

abstract class ServerChannelSelectEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverChannelSelect;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerSelectContext ctx, List<ServerChannel> channels);
}
