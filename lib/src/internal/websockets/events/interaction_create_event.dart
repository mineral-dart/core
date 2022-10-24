import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class InteractionCreateEvent extends Event {
  final Interaction _interaction;

  InteractionCreateEvent(this._interaction);

  Interaction get interaction => _interaction;
}
