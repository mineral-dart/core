import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ModerationRulesCreateEvent extends Event {
  final ModerationRule _rule;

  ModerationRulesCreateEvent(this._rule);

  ModerationRule get rule => _rule;
}