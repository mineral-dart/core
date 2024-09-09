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

  Future<void> allowBypassVerification({String? reason}) =>
      _memberMethods.updateMember(
          serverId: server.id,
          memberId: member.id,
          payload: {'flags': MemberFlag.bypassedVerification.value},
          reason: reason);

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

  Future<void> sync(List<MemberFlag> flags, {String? reason}) {
    final currentFlags = flags.fold(0, (acc, element) => acc + element.value);

    return _memberMethods.updateMember(
        serverId: server.id,
        memberId: member.id,
        payload: {'flags': currentFlags},
        reason: reason);
  }
}
