import 'package:mineral/src/exceptions/shard_exception.dart';

enum Intent {
  guilds(1 << 0),
  guildMembers(1 << 1),
  guildBans(1 << 2),
  guildEmojisAndStickers(1 << 3),
  guildIntegrations(1 << 4),
  guildWebhooks(1 << 5),
  guildInvites(1 << 6),
  guildVoiceStates(1 << 7),
  guildPresences(1 << 8),
  guildMessages(1 << 9),
  guildMessageReactions(1 << 10),
  guildMessageTyping(1 << 11),
  directMessages(1 << 12),
  directMessageReaction(1 << 13),
  directMessageTyping(1 << 14),
  messageContent(1 << 17),
  guildScheduledEvents(1 << 16),
  autoModerationConfiguration(1 << 20),
  autoModerationExecution(1 << 21),
  all(0);

  final int value;
  const Intent(this.value);

  static int getIntent (List<Intent> intents) {
    List<int> values = [];

    List<Intent> source = intents.contains(Intent.all) ? Intent.values : intents;
    for (Intent intent in source) {
      values.add(intent.value);
    }

    if (values.isEmpty) {
      throw ShardException(prefix: 'Missing intents', cause: 'No intent was given, please define which ones are useful to you.');
    }

    return values.reduce((value, element) => value += element);
  }

  @override
  String toString () => value.toString();
}

class IntentManager {
  List<Intent> list = [];

  void defined ({ List<Intent>? intents, bool? all }) {
    if (all == true) {
      list = [Intent.all];
      return;
    }

    if (intents != null) {
      list.addAll(intents);
    }
  }
}
