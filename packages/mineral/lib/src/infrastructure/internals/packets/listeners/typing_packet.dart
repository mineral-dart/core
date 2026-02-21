import 'package:mineral/events.dart';
import 'package:mineral/src/api/common/snowflake.dart';
import 'package:mineral/src/api/common/typing.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class TypingPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.typingStart;

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final typing = Typing(
      serverId: Snowflake.nullable(payload['guild_id']),
      channelId: Snowflake.parse(payload['channel_id']),
      userId: Snowflake.parse(payload['user_id']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(payload['timestamp']),
    );

    dispatch(event: Event.typing, params: [typing]);
  }
}
