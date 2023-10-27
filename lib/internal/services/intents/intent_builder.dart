import 'package:mineral/internal/services/intents/intent.dart';

/// A service that provides intents.
/// Related to official [Discord API](https://discord.com/developers/docs/topics/gateway#gateway-intents) documentation.
final class IntentBuilder {
  final List<Intent> intents = [];

  /// Creates an [IntentBuilder] with [Guild] intents.
  IntentBuilder guilds() {
    intents.add(Intent.guilds);
    return this;
  }

  /// Creates an [IntentBuilder] with [GuildMember] intents.
  IntentBuilder guildMembers() {
    intents.add(Intent.guildMembers);
    return this;
  }

  /// Creates an [IntentBuilder] with [GuildBan] intents.
  IntentBuilder guildBans() {
    intents.add(Intent.guildModeration);
    return this;
  }

  /// Creates an [IntentBuilder] with [Emoji] and [Sticker] intents.
  IntentBuilder guildEmojisAndStickers() {
    intents.add(Intent.guildEmojisAndStickers);
    return this;
  }

  /// Creates an [IntentBuilder] with [GuildIntegration] intents.
  IntentBuilder guildIntegrations() {
    intents.add(Intent.guildIntegrations);
    return this;
  }

  /// Creates an [IntentBuilder] with [GuildWebhook] intents.
  IntentBuilder guildWebhooks() {
    intents.add(Intent.guildWebhooks);
    return this;
  }

  /// Creates an [IntentBuilder] with [GuildInvites] intents.
  IntentBuilder guildInvites() {
    intents.add(Intent.guildInvites);
    return this;
  }

  /// Creates an [IntentBuilder] with [GuildVoiceState] intents.
  IntentBuilder guildVoiceStates() {
    intents.add(Intent.guildVoiceStates);
    return this;
  }

  /// Creates an [IntentBuilder] with [GuildPresences] intents.
  IntentBuilder guildPresences() {
    intents.add(Intent.guildPresences);
    return this;
  }

  /// Creates an [IntentBuilder] with [Messages] intents.
  IntentBuilder guildMessages() {
    intents.add(Intent.guildMessages);
    return this;
  }

  /// Creates an [IntentBuilder] with [MessageReactions] intents.
  IntentBuilder guildMessageReactions() {
    intents.add(Intent.guildMessageReactions);
    return this;
  }

  /// Creates an [IntentBuilder] with [MessageTyping] intents.
  IntentBuilder guildMessageTyping() {
    intents.add(Intent.guildMessageTyping);
    return this;
  }

  /// Creates an [IntentBuilder] with [DirectMessages] intents.
  IntentBuilder directMessages() {
    intents.add(Intent.directMessages);
    return this;
  }

  /// Creates an [IntentBuilder] with [DirectMessageReactions] intents.
  IntentBuilder directMessageReaction() {
    intents.add(Intent.directMessageReaction);
    return this;
  }

  /// Creates an [IntentBuilder] with [DirectMessageTyping] intents.
  IntentBuilder directMessageTyping() {
    intents.add(Intent.directMessageTyping);
    return this;
  }

  /// Creates an [IntentBuilder] with [Message] content intents.
  IntentBuilder messageContent() {
    intents.add(Intent.messageContent);
    return this;
  }

  /// Creates an [IntentBuilder] with [ScheduledEvent] intents.
  IntentBuilder guildScheduledEvents() {
    intents.add(Intent.guildScheduledEvents);
    return this;
  }

  IntentBuilder autoModerationConfiguration() {
    intents.add(Intent.autoModerationConfiguration);
    return this;
  }

  IntentBuilder autoModerationExecution() {
    intents.add(Intent.autoModerationExecution);
    return this;
  }
}