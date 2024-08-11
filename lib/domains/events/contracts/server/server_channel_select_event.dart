import 'dart:async';

import 'package:mineral/api/server/channels/server_channel.dart';
import 'package:mineral/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerChannelSelectEventHandler = FutureOr Function(ServerSelectContext ctx, List<ServerChannel> channels);

abstract class ServerChannelSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.serverChannelSelect;

  String? get customId;

  FutureOr<void> handle(ServerSelectContext ctx, List<ServerChannel> channels);
}
