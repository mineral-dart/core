enum PacketType {
  ready('READY'),

  messageCreate('MESSAGE_CREATE'),
  messageUpdate('MESSAGE_UPDATE'),
  messageDelete('MESSAGE_DELETE'),
  messageDeleteBulk('MESSAGE_DELETE_BULK'),

  messageReactionAdd('MESSAGE_REACTION_ADD'),
  messageReactionRemove('MESSAGE_REACTION_REMOVE'),
  messageReactionRemoveAll('MESSAGE_REACTION_REMOVE_ALL'),

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


  guildBanAdd('GUILD_BAN_ADD'),
  guildBanRemove('GUILD_BAN_REMOVE'),

  guildAuditLogEntryCreate('GUILD_AUDIT_LOG_ENTRY_CREATE'),

  presenceUpdate('PRESENCE_UPDATE'),

  guildRoleCreate('GUILD_ROLE_CREATE'),
  guildRoleUpdate('GUILD_ROLE_UPDATE'),
  guildRoleDelete('GUILD_ROLE_DELETE'),

  guildEmojisUpdate('GUILD_EMOJIS_UPDATE'),
  guildStickersUpdate('GUILD_STICKERS_UPDATE'),

  channelPinsUpdate('CHANNEL_PINS_UPDATE');

  final String name;

  const PacketType(this.name);
}
