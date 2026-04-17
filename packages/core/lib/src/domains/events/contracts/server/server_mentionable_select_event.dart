import 'dart:async';

import 'package:mineral/src/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef ServerMentionableSelectEventHandler = FutureOr<void> Function(
    ServerSelectContext ctx, List<dynamic> mentionables);

abstract class ServerMentionableSelectEvent extends BaseListenableEvent {
  @override
  Event get event => Event.serverMentionableSelect;

  @override
  Function get handler => handle;

  FutureOr<void> handle(ServerSelectContext ctx, List<dynamic> mentionables);
}
