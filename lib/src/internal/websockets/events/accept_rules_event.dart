import 'package:mineral/api.dart';
import 'package:mineral/event.dart';

class AcceptRulesEvent extends Event {
  final GuildMember _member;

  AcceptRulesEvent(this._member);

  GuildMember get member => _member;
}