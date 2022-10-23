import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class GuildCreate extends Event {
  final Guild _guild;

  GuildCreate(this._guild);

  Guild get guild => _guild;
}