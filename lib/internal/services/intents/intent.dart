/// Represents an [Intent] for [Gateway] to receive events.
/// Related to official [Discord API](https://discord.com/developers/docs/topics/gateway#gateway-intents) documentation.
enum Intent {
  /// Allows [Gateway] to receive [Guild]s.
  guilds(1 << 0),

  /// Allows [Gateway] to receive [GuildMember]s.
  guildMembers(1 << 1),

  /// Allows [Gateway] to receive [GuildBan]s.
  guildBans(1 << 2),

  /// Allows [Gateway] to receive [GuildEmoji]s and [GuildSticker]s.
  guildEmojisAndStickers(1 << 3),

  /// Allows [Gateway] to receive [GuildIntegration]s.
  guildIntegrations(1 << 4),

  /// Allows [Gateway] to receive [GuildWebhook]s.
  guildWebhooks(1 << 5),

  /// Allows [Gateway] to receive [GuildInvite]s.
  guildInvites(1 << 6),

  /// Allows [Gateway] to receive [GuildVoiceState]s.
  guildVoiceStates(1 << 7),

  /// Allows [Gateway] to receive [GuildPresence]s.
  guildPresences(1 << 8),

  /// Allows [Gateway] to receive [GuildMessage]s.
  guildMessages(1 << 9),

  /// Allows [Gateway] to receive [GuildMessageReaction]s.
  guildMessageReactions(1 << 10),

  /// Allows [Gateway] to receive [GuildMessageTyping]s.
  guildMessageTyping(1 << 11),

  /// Allows [Gateway] to receive [DirectMessage]s.
  directMessages(1 << 12),

  /// Allows [Gateway] to receive [DirectMessageReaction]s.
  directMessageReaction(1 << 13),

  /// Allows [Gateway] to receive [DirectMessageTyping]s.
  directMessageTyping(1 << 14),

  /// Allows [Gateway] to receive [MessageContent]s without [GuildMember]s.
  messageContent(1 << 17),

  /// Allows [Gateway] to receive [GuildScheduledEvents]s.
  guildScheduledEvents(1 << 16),

  /// Allows [Gateway] to receive [GuildStageInstance]s.
  autoModerationConfiguration(1 << 20),

  /// Allows [Gateway] to receive [GuildStageInstance]s.
  autoModerationExecution(1 << 21);

  final int value;
  const Intent(this.value);
}