import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class InteractionCreateEvent extends Event {
  final Interaction _interaction;

  InteractionCreateEvent(this._interaction);

  Interaction get interaction => _interaction;
}
