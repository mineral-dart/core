import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an bug hunter level 2.
class BugHunterLevel2Flag extends UserFlagContract {
  BugHunterLevel2Flag(): super('Bug Hunter Level 2', 1 << 14, 'f599063762165e0d23e8b11b684765a8.svg');
}