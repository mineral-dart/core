import 'package:mineral/core/api.dart';

/// Represents an [GuildMember] [Activity].
class GuildMemberActivity {
  final ActivityType _type;
  final String _name;

  GuildMemberActivity(this._type, this._name);

  /// The [ActivityType] of this.
  ActivityType get type => _type;

  /// The name of this.
  String get name => _name;
}