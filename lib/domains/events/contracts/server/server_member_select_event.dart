import 'dart:async';

import 'package:mineral/api/server/member.dart';
import 'package:mineral/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef ServerMemberSelectEventHandler = FutureOr Function(ServerSelectContext, List<Member>);

abstract class ServerMemberSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.serverMemberSelect;

  String? get customId;

  FutureOr<void> handle(ServerSelectContext ctx, List<Member> roles);
}
