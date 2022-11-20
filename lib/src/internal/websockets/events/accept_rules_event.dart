import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class AcceptRulesEvent extends Event {
  final GuildMember _member;

  AcceptRulesEvent(this._member);

  GuildMember get member => _member;
}