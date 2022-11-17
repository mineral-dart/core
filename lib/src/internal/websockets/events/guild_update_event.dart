import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class GuildUpdateEvent extends Event {
  final Guild _before;
  final Guild _after;

  GuildUpdateEvent(this._before, this._after);

  Guild get before => _before;
  Guild get after => _after;
}
