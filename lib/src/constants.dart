part of core;

enum OpCode {
  dispatch(0),
  heartbeat(1),
  identify(2),
  statusUpdate(3),
  voiceStateUpdate(4),
  voiceGuildPing(5),
  resume(6),
  reconnect(7),
  requestGuildMember(8),
  invalidSession(9),
  hello(10),
  heartbeatAck(11),
  guildSync(12);

  final int value;
  const OpCode (this.value);
}

enum PacketType {
  ready('READY'),
  guildCreate('GUILD_CREATE'),
  presenceUpdate('PRESENCE_UPDATE'),
  messageCreate('MESSAGE_CREATE'),
  messageUpdate('MESSAGE_UPDATE'),
  messageDelete('MESSAGE_DELETE');

  final String _value;
  const PacketType(this._value);

  @override
  String toString () => _value;
}

class Constants {
  // Discord CDN host
  static const String cdnHost = "discordapp.com";

  // Url for cdn host
  static const String cdnUrl = "https://cdn.${Constants.cdnHost}";

  // Discord API host
  static const String host = "discord.com";

  // Base API uri
  static const String baseUri = "/api/v$apiVersion";

  // Version of API
  static const int apiVersion = 10;
}
