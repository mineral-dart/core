enum PacketType {
  ready('READY'),
  guildCreate('GUILD_CREATE'),
  guildUpdate('GUILD_UPDATE'),
  guildDelete('GUILD_DELETE'),

  guildIntegrationsUpdate('GUILD_INTEGRATIONS_UPDATE'),

  presenceUpdate('PRESENCE_UPDATE'),

  autoModerationRuleCreate('AUTO_MODERATION_RULE_CREATE'),
  autoModerationRuleDelete('AUTO_MODERATION_RULE_DELETE'),

  guildScheduledEventCreate('GUILD_SCHEDULED_EVENT_CREATE'),
  guildScheduledEventDelete('GUILD_SCHEDULED_EVENT_DELETE'),
  guildScheduledEventUpdate('GUILD_SCHEDULED_EVENT_UPDATE'),
  guildScheduledEventUserAdd('GUILD_SCHEDULED_EVENT_USER_ADD'),
  guildScheduledEventUserRemove('GUILD_SCHEDULED_EVENT_USER_REMOVE'),
  guildMemberChunk('GUILD_MEMBERS_CHUNK'),

  webhookUpdate('WEBHOOKS_UPDATE'),

  messageCreate('MESSAGE_CREATE'),
  messageUpdate('MESSAGE_UPDATE'),
  messageDelete('MESSAGE_DELETE'),
  messageReactionAdd('MESSAGE_REACTION_ADD'),
  messageReactionRemove('MESSAGE_REACTION_REMOVE'),
  messageReactionRemoveAll('MESSAGE_REACTION_REMOVE_ALL'),
  messageReactionRemoveEmoji('MESSAGE_REACTION_REMOVE_EMOJI'),

  channelCreate('CHANNEL_CREATE'),
  channelUpdate('CHANNEL_UPDATE'),
  channelDelete('CHANNEL_DELETE'),

  interactionCreate('INTERACTION_CREATE'),

  inviteCreate('INVITE_CREATE'),
  inviteDelete('INVITE_DELETE'),

  memberUpdate('GUILD_MEMBER_UPDATE'),
  memberRemove('GUILD_MEMBER_REMOVE'),
  memberAdd('GUILD_MEMBER_ADD'),

  memberJoinRequest('GUILD_JOIN_REQUEST_UPDATE'),

  voiceStateUpdate('VOICE_STATE_UPDATE'),

  resumed('RESUMED');

  final String value;
  const PacketType(this.value);
}