import 'package:mineral/internal/services/intents/intent.dart';

final class IntentBuilder {
  final List<Intent> intents = [];

  IntentBuilder guilds() {
    intents.add(Intent.guilds);
    return this;
  }

  IntentBuilder guildMembers() {
    intents.add(Intent.guildMembers);
    return this;
  }

  IntentBuilder guildBans() {
    intents.add(Intent.guildBans);
    return this;
  }

  IntentBuilder guildEmojisAndStickers() {
    intents.add(Intent.guildEmojisAndStickers);
    return this;
  }

  IntentBuilder guildIntegrations() {
    intents.add(Intent.guildIntegrations);
    return this;
  }

  IntentBuilder guildWebhooks() {
    intents.add(Intent.guildWebhooks);
    return this;
  }

  IntentBuilder guildInvites() {
    intents.add(Intent.guildInvites);
    return this;
  }

  IntentBuilder guildVoiceStates() {
    intents.add(Intent.guildVoiceStates);
    return this;
  }

  IntentBuilder guildPresences() {
    intents.add(Intent.guildPresences);
    return this;
  }

  IntentBuilder guildMessages() {
    intents.add(Intent.guildMessages);
    return this;
  }

  IntentBuilder guildMessageReactions() {
    intents.add(Intent.guildMessageReactions);
    return this;
  }

  IntentBuilder guildMessageTyping() {
    intents.add(Intent.guildMessageTyping);
    return this;
  }

  IntentBuilder directMessages() {
    intents.add(Intent.directMessages);
    return this;
  }

  IntentBuilder directMessageReaction() {
    intents.add(Intent.directMessageReaction);
    return this;
  }

  IntentBuilder directMessageTyping() {
    intents.add(Intent.directMessageTyping);
    return this;
  }

  IntentBuilder messageContent() {
    intents.add(Intent.messageContent);
    return this;
  }

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