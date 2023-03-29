import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class UserMenuCreateEvent extends Event {
  final UserMenuInteraction _interaction;

  UserMenuCreateEvent(this._interaction);

  UserMenuInteraction get interaction => _interaction;
}
