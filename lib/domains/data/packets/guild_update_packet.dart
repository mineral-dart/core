import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/mineral_event.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildUpdate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildUpdatePacket(this.logger, this.marshaller);

  @override
  void listen(ShardMessage message, DispatchEvent dispatch) {
    final Snowflake serverId = Snowflake(message.payload['id']);

    final before = marshaller.storage.servers[serverId];
    final after = marshaller.serializers.server.serialize(message.payload);

    dispatch(event: MineralEvent.serverUpdate, params: [before, after]);

    marshaller.storage.servers[serverId] = after;
  }
}
