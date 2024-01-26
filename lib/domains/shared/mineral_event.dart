abstract interface class EventList {
  String get name;
}

final class MineralEvent implements EventList {
  @override
  final String name;

  const MineralEvent(this.name);

  static final ready = MineralEvent('Ready');
  static final serverCreate = MineralEvent('ServerCreate');
  static final serverMessageCreate = MineralEvent('ServerMessageCreate');
  static final serverChannelCreate = MineralEvent('ServerChannelCreate');
  static final serverChannelUpdate = MineralEvent('ServerChannelUpdate');
}
