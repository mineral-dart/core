import 'package:mineral/api.dart';

enum StatusType {
  online('online'),
  idle('idle'),
  doNotDisturb('dnd'),
  offline('offline');

  final String _value;
  const StatusType(this._value);

  @override
  String toString () => _value;
}

class Status {
  User _user;
  Guild _guild;
  StatusType _type;
  List<Activity> _activities;
  dynamic _platform;

  Status(
    this._user,
    this._guild,
    this._type,
    this._activities,
    this._platform,
  );

  User get user => _user;
  Guild get guild => _guild;
  StatusType get type => _type;
  List<Activity> get activities => _activities;
  dynamic get platform => _platform;

  factory Status.from({ required Guild guild, required dynamic payload }) {
    GuildMember guildMember = guild.members.cache.get(payload['user']['id'])!;

    List<Activity> activities = [];

    for (dynamic element in payload['activities']) {
      Activity activity = Activity.from(payload: element);
      activities.add(activity);
    }

    return Status(
      guildMember.user,
      guild,
      StatusType.values.firstWhere((status) => status.toString() == payload['status']),
      activities,
      payload['client_status'],
    );
  }
}
