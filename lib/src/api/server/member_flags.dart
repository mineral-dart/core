import 'package:mineral/src/api/server/enums/member_flag.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/api/server/server.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/member_part.dart';

final class MemberFlagsManager {
  final List<MemberFlag> _flags;

  late final Server server;
  late final Member member;

  MemberPart get _memberMethods => ioc.resolve<DataStoreContract>().member;

  List<MemberFlag> get list => _flags;

  MemberFlagsManager(this._flags);

  /// Allow the member to bypass verification.
  ///
  /// ```dart
  /// await member.flags.allowBypassVerification(reason: 'Testing');
  /// ```
  Future<void> allowBypassVerification({String? reason}) =>
      _memberMethods.updateMember(
          serverId: server.id,
          memberId: member.id,
          payload: {'flags': MemberFlag.bypassedVerification.value},
          reason: reason);

  /// Disallow the member to bypass verification.
  ///
  /// ```dart
  /// await member.flags.disallowBypassVerification(reason: 'Testing');
  /// ```
  Future<void> disallowBypassVerification({String? reason}) {
    final currentFlags = _flags.fold(0, (acc, element) => acc + element.value);

    return _memberMethods.updateMember(
        serverId: server.id,
        memberId: member.id,
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

    return _memberMethods.updateMember(
        serverId: server.id,
        memberId: member.id,
        payload: {'flags': currentFlags},
        reason: reason);
  }
}
