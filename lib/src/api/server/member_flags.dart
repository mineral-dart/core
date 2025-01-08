import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/api/server/enums/member_flag.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';

final class MemberFlagsManager {
  final List<MemberFlag> _flags;

  late final Server server;
  late final Member member;

  MemberPartContract get _memberMethods =>
      ioc.resolve<DataStoreContract>().member;

  List<MemberFlag> get list => _flags;

  MemberFlagsManager(this._flags);

  /// Allow the member to bypass verification.
  ///
  /// ```dart
  /// await member.flags.allowBypassVerification(reason: 'Testing');
  /// ```
  Future<void> allowBypassVerification({String? reason}) =>
      _memberMethods.update(
          serverId: server.id.value,
          memberId: member.id.value,
          payload: {'flags': MemberFlag.bypassedVerification.value},
          reason: reason);

  /// Disallow the member to bypass verification.
  ///
  /// ```dart
  /// await member.flags.disallowBypassVerification(reason: 'Testing');
  /// ```
  Future<void> disallowBypassVerification({String? reason}) {
    final currentFlags = _flags.fold(0, (acc, element) => acc + element.value);

    return _memberMethods.update(
        serverId: server.id.value,
        memberId: member.id.value,
        payload: {
          'flags': currentFlags - MemberFlag.bypassedVerification.value
        },
        reason: reason);
  }

  /// Sync the member's flags.
  ///
  /// ```dart
  /// await member.flags.sync([MemberFlag.bypassedVerification], reason: 'Testing');
  /// ```
  Future<void> sync(List<MemberFlag> flags, {String? reason}) {
    final currentFlags = flags.fold(0, (acc, element) => acc + element.value);

    return _memberMethods.update(
        serverId: server.id.value,
        memberId: member.id.value,
        payload: {'flags': currentFlags},
        reason: reason);
  }
}
