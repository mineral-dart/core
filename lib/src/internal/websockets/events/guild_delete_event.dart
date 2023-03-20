import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class GuildDeleteEvent extends Event {
  final Guild _guild;

  GuildDeleteEvent(this._guild);

  Guild get guild => _guild;
}