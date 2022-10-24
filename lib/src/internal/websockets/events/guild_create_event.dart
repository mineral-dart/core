import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildCreateEvent extends Event {
  final Guild _guild;

  GuildCreateEvent(this._guild);

  Guild get guild => _guild;
}