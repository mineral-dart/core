import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/events.dart';
import 'package:mineral/src/domains/services/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class ThreadMembersUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.threadMembersUpdate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await _dataStore.server.get(message.payload['guild_id'], false);
    final thread = await _dataStore.channel.get<ThreadChannel>(message.payload['id'], false);

    await List.from(message.payload['added_members']).map((element) async {
      Member? member;
      if (element['member'] != null) {
        member = await _dataStore.member.get(message.payload['guild_id'], element['user_id'], false);
      } else {
        final rawMember = await _marshaller.serializers.member.normalize(element);
        member = await _marshaller.serializers.member.serialize(rawMember);
      }

      dispatch(event: Event.serverThreadMemberAdd, params: [server, thread, member]);
    }).wait;

    await List.from(message.payload['removed_member_ids']).map((element) async {
      Member? member;
      if (element['member'] != null) {
        member = await _dataStore.member.get(message.payload['guild_id'], element['user_id'], false);
      } else {
        final rawMember = await _marshaller.serializers.member.normalize(element);
        member = await _marshaller.serializers.member.serialize(rawMember);
      }

      dispatch(event: Event.serverThreadMemberRemove, params: [server, thread, member]);
    }).wait;
  }
}
