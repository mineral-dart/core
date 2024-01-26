enum PacketType {
  ready('READY'),
  messageCreate('MESSAGE_CREATE'),
  guildCreate('GUILD_CREATE'),
  channelCreate('CHANNEL_CREATE'),
  channelUpdate('CHANNEL_UPDATE'),
  channelDelete('CHANNEL_DELETE'),
  channelPinsUpdate('CHANNEL_PINS_UPDATE');

  final String name;

  const PacketType(this.name);
}
