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
  guildUpdate('GUILD_UPDATE'),

  guildIntegrationsUpdate('GUILD_INTEGRATIONS_UPDATE'),

  presenceUpdate('PRESENCE_UPDATE'),

  autoModerationRuleCreate('AUTO_MODERATION_RULE_CREATE'),
  autoModerationRuleDelete('AUTO_MODERATION_RULE_DELETE'),

  guildScheduledEventCreate('GUILD_SCHEDULED_EVENT_CREATE'),
  guildScheduledEventDelete('GUILD_SCHEDULED_EVENT_DELETE'),
  guildScheduledEventUpdate('GUILD_SCHEDULED_EVENT_UPDATE'),
  guildScheduledEventUserAdd('GUILD_SCHEDULED_EVENT_USER_ADD'),
  guildScheduledEventUserRemove('GUILD_SCHEDULED_EVENT_USER_REMOVE'),

  webhookUpdate('WEBHOOKS_UPDATE'),

  messageCreate('MESSAGE_CREATE'),
  messageUpdate('MESSAGE_UPDATE'),
  messageDelete('MESSAGE_DELETE'),

  channelCreate('CHANNEL_CREATE'),
  channelUpdate('CHANNEL_UPDATE'),
  channelDelete('CHANNEL_DELETE'),

  interactionCreate('INTERACTION_CREATE'),

  memberUpdate('GUILD_MEMBER_UPDATE'),
  memberRemove('GUILD_MEMBER_REMOVE'),
  memberAdd('GUILD_MEMBER_ADD'),

  memberJoinRequest('GUILD_JOIN_REQUEST_UPDATE'),

  resumed('RESUMED');

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
