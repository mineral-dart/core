import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class CommandCreateEvent extends Event {
  final CommandInteraction _interaction;

  CommandCreateEvent(this._interaction);

  CommandInteraction get interaction => _interaction;
  GuildMember get sender => _interaction.member!;
}
