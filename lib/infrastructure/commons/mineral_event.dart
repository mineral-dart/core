abstract interface class EventList {
  String get name;
}

final class MineralEvent implements EventList {
  @override
  final String name;

  const MineralEvent(this.name);

  static final ready = MineralEvent('Ready');

  static final serverCreate = MineralEvent('ServerCreate');
  static final serverUpdate = MineralEvent('ServerUpdate');
  static final serverDelete = MineralEvent('ServerDelete');

  static final serverMessageCreate = MineralEvent('ServerMessageCreate');

  static final serverChannelCreate = MineralEvent('ServerChannelCreate');
  static final serverChannelUpdate = MineralEvent('ServerChannelUpdate');
  static final serverChannelDelete = MineralEvent('ServerChannelDelete');
  static final serverChannelPinsUpdate = MineralEvent('ServerChannelPinsUpdate');
  static final privateChannelPinsUpdate = MineralEvent('PrivateChannelPinsUpdate');

  static final serverMemberAdd = MineralEvent('ServerMemberAdd');
  static final serverMemberRemove = MineralEvent('ServerMemberRemove');

  static final serverBanAdd = MineralEvent('ServerBanAdd');
  static final serverBanRemove = MineralEvent('ServerBanRemove');

  static final serverMemberUpdate = MineralEvent('ServerMemberUpdate');
  static final serverPresenceUpdate = MineralEvent('ServerPresenceUpdate');

  static final serverEmojisUpdate = MineralEvent('ServerEmojisUpdate');
  static final serverStickersUpdate = MineralEvent('ServerStickersUpdate');

  static final serverRoleCreate = MineralEvent('ServerRoleCreate');
  static final serverRoleUpdate = MineralEvent('ServerRoleUpdate');
  static final serverRoleDelete = MineralEvent('ServerRoleDelete');

  // private
  static final privateMessageCreate = MineralEvent('PrivateMessageCreate');
  static final privateChannelCreate = MineralEvent('PrivateChannelCreate');
  static final privateChannelUpdate = MineralEvent('PrivateChannelUpdate');
  static final privateChannelDelete = MineralEvent('PrivateChannelDelete');

  // voice
}
