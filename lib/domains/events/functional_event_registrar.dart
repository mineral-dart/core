import 'dart:async';

import 'package:mineral/domains/events/internal_event.dart';
import 'package:mineral/domains/events/types/packet_type.dart';
import 'package:mineral/domains/shared/types/mineral_client_contract.dart';

abstract interface class FunctionalEventRegistrarContract {
  void make(String event, Function() handle);

  void ready(FutureOr<void> Function() handle);
}

final class FunctionalEventRegistrar implements FunctionalEventRegistrarContract {
  final MineralClientContract _client;

  FunctionalEventRegistrar(this._client);

  @override
  void make(String event, Function() handle) => _registerEvent(InternalEvent(event, handle));

  @override
  void ready(FutureOr<void> Function() handle) => _registerEvent(InternalEvent(PacketType.ready.toString(), handle));

  void _registerEvent(InternalEvent event) =>
      _client.kernel.eventManager.events.listen(event);
}
