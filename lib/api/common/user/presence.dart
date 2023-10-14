import 'dart:math';

import 'package:mineral/api/common/contracts/presence_contracts.dart';
import 'package:mineral/api/common/resources/activities/user_activity.dart';
import 'package:mineral/api/common/resources/activities/user_status.dart';

final class Presence implements PresenceContracts {
  @override
  final UserStatus status;

  @override
  final String? broadcast;

  @override
  final List<UserActivity> activities;

  Presence._({
    required this.status,
    this.broadcast,
    required this.activities,
  });

  factory Presence.fromWss(final payload) =>
    Presence._(
      status: UserStatus.values.firstWhere((e) => e.value == payload['status']),
      broadcast: payload['broadcast'],
      activities: payload['activities'].map<UserActivity>((activity) => UserActivity.fromWss(activity)).toList(),
    );
}