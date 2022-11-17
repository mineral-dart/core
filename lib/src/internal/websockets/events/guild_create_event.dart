import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class GuildCreateEvent extends Event {
  final Guild _guild;

  GuildCreateEvent(this._guild);

  Guild get guild => _guild;
}