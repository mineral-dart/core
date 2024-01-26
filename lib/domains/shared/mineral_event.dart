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
}
