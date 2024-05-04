import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/member_part.dart';

final class MemberVoice {
  MemberPart get _memberMethods => DataStore.singleton().member;
  final Member _member;

  MemberVoice(this._member);

  Future<void> move(Snowflake channelId, {String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'channel_id': channelId},
      reason: reason,
    );
  }

  Future<void> disconnect({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'channel_id': null},
      reason: reason,
    );
  }

  Future<void> mute({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'mute': true},
      reason: reason,
    );
  }

  Future<void> unMute({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'mute': false},
      reason: reason,
    );
  }

  Future<void> deafen({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'deaf': true},
      reason: reason,
    );
  }

  Future<void> unDeafen({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'deaf': false},
      reason: reason,
    );
  }
}
