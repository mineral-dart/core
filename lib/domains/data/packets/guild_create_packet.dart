import 'package:mineral/api/server/server.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildCreatePacket implements ListenablePacket {
  @override
  PacketType get event => PacketType.guildCreate;

  final LoggerContract logger;
  final MarshallerContract marshaller;

  const GuildCreatePacket(this.logger, this.marshaller);

  @override
  void listen(ShardMessage message, DispatchEvent dispatch) {
    final server = marshaller.serializers.server.serialize(message.payload);

    marshaller.storage.servers[server.id] = server;
    marshaller.storage.channels.addAll(server.channels.list);

    dispatch(event: 'ServerCreateEvent', params: [server]);
  }
}
