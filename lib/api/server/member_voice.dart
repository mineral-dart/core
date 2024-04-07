import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/data_store/parts/member_part.dart';

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
}
