import 'package:mineral/contracts.dart';
import 'package:mineral/events.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class InviteCreatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.inviteCreate;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final normalized = await _marshaller.serializers.invite.normalize(
      message.payload,
    );
    final invite = await _marshaller.serializers.invite.serialize(
      normalized,
    );

    dispatch(event: Event.inviteCreate, params: [invite]);
  }
}
