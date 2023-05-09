import 'package:mineral/core/api.dart';

/// A flag that indicates that the user is an bug hunter level 1.
class BugHunterLevel1Flag extends UserFlagContract {
  BugHunterLevel1Flag(): super('Bug Hunter Level 1', 1 << 3, '8353d89b529e13365c415aef08d1d1f4.svg');
}