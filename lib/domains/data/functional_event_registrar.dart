import 'package:mineral/domains/data/events/message_create_event.dart';
import 'package:mineral/domains/data/events/ready_event.dart';
import 'package:mineral/domains/data/events/server_create_event.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/shared/types/mineral_client_contract.dart';

abstract interface class FunctionalEventRegistrarContract {
  void make(String event, Function() handle);

  void ready(ReadyEventHandler handle);

  void serverCreate(ServerCreateEventHandler handle);

  void serverMessageCreate(ServerMessageEventHandler handle);

  void privateMessageCreate(PrivateMessageEventHandler handle);
}

final class FunctionalEventRegistrar implements FunctionalEventRegistrarContract {
  final MineralClientContract _client;

  FunctionalEventRegistrar(this._client);

  @override
  void make(String event, Function() handle) => _registerEvent(event: event, handle: handle);

  @override
  void ready(ReadyEventHandler handle) =>
      _registerEvent(event: PacketType.ready.toString(), handle: handle);

  @override
  void serverCreate(ServerCreateEventHandler handle) =>
      _registerEvent(event: 'ServerCreateEvent', handle: handle);

  @override
  void serverMessageCreate(ServerMessageEventHandler handle) =>
      _registerEvent(event: 'ServerMessageEvent', handle: handle);

  void privateMessageCreate(PrivateMessageEventHandler handle) =>
      _registerEvent(event: 'PrivateMessageEvent', handle: handle);

  void _registerEvent<T extends Function>({required String event, required T handle}) =>
      _client.kernel.dataListener.events.listen(
        event: event,
        handle: handle,
      );
}
