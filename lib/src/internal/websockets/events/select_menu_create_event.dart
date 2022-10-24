import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class SelectMenuCreateEvent extends Event {
  final SelectMenuInteraction _interaction;

  SelectMenuCreateEvent(this._interaction);

  SelectMenuInteraction get interaction => _interaction;
  GuildMember get sender => _interaction.member!;
}
