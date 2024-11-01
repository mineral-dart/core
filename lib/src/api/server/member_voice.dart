import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/server/member.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/member_part.dart';

final class MemberVoice {
  MemberPart get _memberMethods => ioc.resolve<DataStoreContract>().member;
  final Member _member;

  MemberVoice(this._member);

  /// Move the member to a different voice channel.
  ///
  /// ```dart
  /// await member.voice.move(channelId, reason: 'Testing');
  /// ```
  Future<void> move(Snowflake channelId, {String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'channel_id': channelId},
      reason: reason,
    );
  }

  /// Disconnect the member from the voice channel.
  ///
  /// ```dart
  /// await member.voice.disconnect(reason: 'Testing');
  /// ```
  Future<void> disconnect({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'channel_id': null},
      reason: reason,
    );
  }

  /// Mute the member.
  ///
  /// ```dart
  /// await member.voice.mute(reason: 'Testing');
  /// ```
  Future<void> mute({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'mute': true},
      reason: reason,
    );
  }

  /// Unmute the member.
  ///
  /// ```dart
  /// await member.voice.unMute(reason: 'Testing');
  /// ```
  Future<void> unMute({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'mute': false},
      reason: reason,
    );
  }

  /// Deafen the member.
  ///
  /// ```dart
  /// await member.voice.deafen(reason: 'Testing');
  /// ```
  Future<void> deafen({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'deaf': true},
      reason: reason,
    );
  }

  /// UnDeafen the member.
  ///
  /// ```dart
  /// await member.voice.unDeafen(reason: 'Testing');
  /// ```
  Future<void> unDeafen({String? reason}) async {
    await _memberMethods.updateMember(
      serverId: _member.server.id,
      memberId: _member.id,
      payload: {'deaf': false},
      reason: reason,
    );
  }


}
