import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class ModerationRulesUpdateEvent extends Event {
  final ModerationRule? _before;
  final ModerationRule _after;

  ModerationRulesUpdateEvent(this._before, this._after);

  ModerationRule? get before => _before;
  ModerationRule get after => _after;
}