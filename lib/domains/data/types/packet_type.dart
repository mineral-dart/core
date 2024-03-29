enum PacketType {
  ready('READY'),
  messageCreate('MESSAGE_CREATE'),
  guildCreate('GUILD_CREATE'),
  guildUpdate('GUILD_UPDATE'),
  guildDelete('GUILD_DELETE'),
  channelCreate('CHANNEL_CREATE'),
  channelUpdate('CHANNEL_UPDATE'),
  channelDelete('CHANNEL_DELETE'),
  guildMemberAdd('GUILD_MEMBER_ADD'),
  guildMemberRemove('GUILD_MEMBER_REMOVE'),
  guildMemberUpdate('GUILD_MEMBER_UPDATE'),
  guildMemberChunk('GUILD_MEMBER_CHUNK'),

  guildRoleCreate('GUILD_ROLE_CREATE'),
  guildRoleUpdate('GUILD_ROLE_UPDATE'),
  guildRoleDelete('GUILD_ROLE_DELETE'),

  channelPinsUpdate('CHANNEL_PINS_UPDATE');

  final String name;

  const PacketType(this.name);
}
