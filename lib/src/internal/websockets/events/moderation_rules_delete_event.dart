import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class ModerationRulesDeleteEvent extends Event {
  final ModerationRule _rule;

  ModerationRulesDeleteEvent(this._rule);

  ModerationRule get rule => _rule;
}