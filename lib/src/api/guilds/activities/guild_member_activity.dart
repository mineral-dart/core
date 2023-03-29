import 'package:mineral/core/api.dart';

class GuildMemberActivity {
  final ActivityType _type;
  final String _name;

  GuildMemberActivity(this._type, this._name);

  ActivityType get type => _type;
  String get name => _name;
}