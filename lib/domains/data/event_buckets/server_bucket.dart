import 'package:mineral/domains/data/event_bucket.dart';
import 'package:mineral/domains/data/events/server/server_channel_create_event.dart';
import 'package:mineral/domains/data/events/server/server_channel_delete_event.dart';
import 'package:mineral/domains/data/events/server/server_channel_pins_update_event.dart';
import 'package:mineral/domains/data/events/server/server_channel_update_event.dart';
import 'package:mineral/domains/data/events/server/server_create_event.dart';
import 'package:mineral/domains/data/events/server/server_delete_event.dart';
import 'package:mineral/domains/data/events/server/server_member_add_event.dart';
import 'package:mineral/domains/data/events/server/server_member_remove_event.dart';
import 'package:mineral/domains/data/events/server/server_member_update_event.dart';
import 'package:mineral/domains/data/events/server/server_message_create_event.dart';
import 'package:mineral/domains/data/events/server/server_update_event.dart';
import 'package:mineral/domains/shared/mineral_event.dart';

final class ServerBucket {
  final EventBucket _events;

  ServerBucket(this._events);

  void serverCreate(ServerCreateEventHandler handle) =>
      _events.make(MineralEvent.serverCreate, handle);

  void serverUpdate(ServerUpdateEventHandler handle) =>
      _events.make(MineralEvent.serverUpdate, handle);

  void serverDelete(ServerDeleteEventHandler handle) =>
      _events.make(MineralEvent.serverDelete, handle);

  void messageCreate(ServerMessageEventHandler handle) =>
      _events.make(MineralEvent.serverMessageCreate, handle);

  void channelCreate(ServerChannelCreateEventHandler handle) =>
      _events.make(MineralEvent.serverChannelCreate, handle);

  void channelUpdate(ServerChannelUpdateEventHandler handle) =>
      _events.make(MineralEvent.serverChannelUpdate, handle);

  void channelDelete(ServerChannelDeleteEventHandler handle) =>
      _events.make(MineralEvent.serverChannelDelete, handle);

  void channelPinsUpdate(ServerChannelPinsUpdateEventHandler handle) =>
      _events.make(MineralEvent.serverChannelPinsUpdate, handle);

  void memberAdd(ServerMemberAddEventHandler handle) =>
      _events.make(MineralEvent.serverMemberAdd, handle);

  void memberRemove(ServerMemberRemoveEventHandler handle) =>
      _events.make(MineralEvent.serverMemberRemove, handle);

  void memberUpdate(ServerMemberUpdateEventHandler handle) =>
      _events.make(MineralEvent.serverMemberUpdate, handle);
}
