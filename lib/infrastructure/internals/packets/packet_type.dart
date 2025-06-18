enum PacketType {
  ready('READY'),

  interactionCreate('INTERACTION_CREATE'),

  messageCreate('MESSAGE_CREATE'),

  threadCreate('THREAD_CREATE'),
  threadUpdate('THREAD_UPDATE'),
  threadDelete('THREAD_DELETE'),
  threadListSync('THREAD_LIST_SYNC'),
  threadMemberUpdate('THREAD_MEMBER_UPDATE'),
  threadMembersUpdate('THREAD_MEMBERS_UPDATE'),

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

  channelPinsUpdate('CHANNEL_PINS_UPDATE'),
  
  autoModRuleCreate('AUTO_MODERATION_RULE_CREATE'),
  autoModRuleUpdate('AUTO_MODERATION_RULE_UPDATE'),
  autoModRuleDelete('AUTO_MODERATION_RULE_DELETE'),
  autoModActionExecution('AUTO_MODERATION_ACTION_EXECUTION');

  final String name;

  const PacketType(this.name);
}