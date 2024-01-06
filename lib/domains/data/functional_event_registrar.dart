import 'package:mineral/domains/data/events/message_create_event.dart';
import 'package:mineral/domains/data/events/ready_event.dart';
import 'package:mineral/domains/data/events/server_create_event.dart';
import 'package:mineral/domains/data/internal_event.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/shared/types/mineral_client_contract.dart';

abstract interface class FunctionalEventRegistrarContract {
  void make(String event, Function() handle);

  void ready(ReadyEventHandler handle);

  void serverCreate(ServerCreateEventHandler handle);

  void serverMessageCreate(ServerMessageEventHandler handle);
}

final class FunctionalEventRegistrar implements FunctionalEventRegistrarContract {
  final MineralClientContract _client;

  FunctionalEventRegistrar(this._client);

  @override
  void make(String event, Function() handle) => _registerEvent(InternalEvent(event, handle));

  @override
  void ready(ReadyEventHandler handle) =>
      _registerEvent(InternalEvent(PacketType.ready.toString(), handle));

  @override
  void serverCreate(ServerCreateEventHandler handle) =>
      _registerEvent(InternalEvent('ServerCreateEvent', handle));

  @override
  void serverMessageCreate(ServerMessageEventHandler handle) =>
      _registerEvent(InternalEvent('ServerMessageEvent', handle));

  void _registerEvent(InternalEvent event) => _client.kernel.dataListener.events.listen(event);
}
