import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class ModalCreateEvent extends Event {
  final ModalInteraction _interaction;

  ModalCreateEvent(this._interaction);

  ModalInteraction get interaction => _interaction;
  GuildMember get sender => _interaction.member!;
}
