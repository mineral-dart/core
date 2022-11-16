import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ModerationRulesDeleteEvent extends Event {
  final ModerationRule _rule;

  ModerationRulesDeleteEvent(this._rule);

  ModerationRule get rule => _rule;
}