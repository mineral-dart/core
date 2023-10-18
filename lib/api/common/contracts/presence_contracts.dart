import 'package:mineral/api/common/resources/activities/user_activity.dart';
import 'package:mineral/api/common/resources/activities/user_status.dart';

abstract interface class PresenceContracts {
  abstract final UserStatus status;
  abstract final String? broadcast;
  abstract final List<UserActivity> activities;
}