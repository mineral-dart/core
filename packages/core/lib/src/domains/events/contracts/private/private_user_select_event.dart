import 'dart:async';

import 'package:mineral/src/api/private/user.dart';
import 'package:mineral/src/domains/components/selects/contexts/private_select_context.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/types/base_listenable_event.dart';

typedef PrivateUserSelectEventHandler = FutureOr Function(
    PrivateSelectContext, List<User>);

abstract class PrivateUserSelectEvent extends BaseListenableEvent {
  @override
  Event get event => Event.privateUserSelect;

  @override
  Function get handler => handle;

  FutureOr<void> handle(PrivateSelectContext ctx, List<User> users);
}
