import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class ModerationRulesCreateEvent extends Event {
  final ModerationRule _rule;

  ModerationRulesCreateEvent(this._rule);

  ModerationRule get rule => _rule;
}