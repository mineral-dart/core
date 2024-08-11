import 'dart:async';

import 'package:mineral/api/private/user.dart';
import 'package:mineral/domains/components/selects/contexts/private_select_context.dart';
import 'package:mineral/domains/components/selects/contexts/server_select_context.dart';
import 'package:mineral/domains/events/event.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';

typedef PrivateUserSelectEventHandler = FutureOr Function(ServerSelectContext, List<User>);

abstract class PrivateUserSelectEvent implements ListenableEvent {
  @override
  Event get event => Event.privateUserSelect;

  String? get customId;

  FutureOr<void> handle(PrivateSelectContext ctx, List<User> roles);
}
