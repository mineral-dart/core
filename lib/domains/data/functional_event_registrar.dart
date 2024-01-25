import 'package:mineral/domains/data/events/message_create_event.dart';
import 'package:mineral/domains/data/events/ready_event.dart';
import 'package:mineral/domains/data/events/server_channel_create_event.dart';
import 'package:mineral/domains/data/events/server_create_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/shared/types/mineral_client_contract.dart';

abstract interface class FunctionalEventRegistrarContract {
  void make(EventList event, Function() handle);

  void ready(ReadyEventHandler handle);

  void serverCreate(ServerCreateEventHandler handle);

  void serverMessageCreate(ServerMessageEventHandler handle);

  void serverChannelCreate(ServerChannelCreateEventHandler handle);

  void privateMessageCreate(PrivateMessageEventHandler handle);
}

final class FunctionalEventRegistrar implements FunctionalEventRegistrarContract {
  final MineralClientContract _client;

  FunctionalEventRegistrar(this._client);

  @override
  void make(EventList event, Function() handle) => _registerEvent(event: event, handle: handle);

  @override
  void ready(ReadyEventHandler handle) =>
      _registerEvent(event: MineralEvent.ready, handle: handle);

  @override
  void serverCreate(ServerCreateEventHandler handle) =>
      _registerEvent(event: MineralEvent.serverCreate, handle: handle);

  @override
  void serverMessageCreate(ServerMessageEventHandler handle) =>
      _registerEvent(event: MineralEvent.serverMessageCreate, handle: handle);

  @override
  void serverChannelCreate(ServerChannelCreateEventHandler handle) =>
      _registerEvent(event: MineralEvent.serverChannelCreate, handle: handle);

  void privateMessageCreate(PrivateMessageEventHandler handle) =>
      _registerEvent(event: MineralEvent.serverMessageCreate, handle: handle);
// todo
  void _registerEvent<T extends Function>({required EventList event, required T handle}) =>
      _client.kernel.dataListener.events.listen(
        event: event,
        handle: handle,
      );
}
