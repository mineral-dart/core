enum PacketType {
  ready('READY'),
  messageCreate('MESSAGE_CREATE'),
  guildCreate('GUILD_CREATE'),
  channelCreate('CHANNEL_CREATE');

  final String name;

  const PacketType(this.name);
}
