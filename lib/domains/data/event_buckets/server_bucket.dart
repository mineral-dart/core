import 'package:mineral/domains/data/event_bucket.dart';
import 'package:mineral/domains/data/events/message_create_event.dart';
import 'package:mineral/domains/data/events/server_channel_create_event.dart';
import 'package:mineral/domains/data/events/server_channel_update_event.dart';
import 'package:mineral/domains/data/events/server_create_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

final class ServerBucket {
  final EventBucket _events;

  ServerBucket(this._events);

  void serverCreate(ServerCreateEventHandler handle) =>
      _events.make(MineralEvent.serverCreate, handle);

  void messageCreate(ServerMessageEventHandler handle) =>
      _events.make(MineralEvent.serverMessageCreate, handle);

  void channelCreate(ServerChannelCreateEventHandler handle) =>
      _events.make(MineralEvent.serverChannelCreate, handle);

  void channelUpdate(ServerChannelUpdateEventHandler handle) =>
      _events.make(MineralEvent.serverChannelUpdate, handle);
}
