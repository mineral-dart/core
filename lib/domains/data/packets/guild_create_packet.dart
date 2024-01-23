import 'package:mineral/api/server/server.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';
import 'package:mineral/domains/data/types/listenable_packet.dart';
import 'package:mineral/domains/data/types/packet_type.dart';
import 'package:mineral/domains/wss/shard_message.dart';

final class GuildCreatePacket implements ListenablePacket {
  @override
  PacketType get event => PacketType.guildCreate;

  final LoggerContract logger;
  final MemoryStorageContract storage;

  const GuildCreatePacket(this.logger, this.storage);

  @override
  void listen(
      ShardMessage message, Function({required String event, required List params}) dispatch) {
    final guild = Server.fromJson(storage, message.payload);

    storage.servers[guild.id] = guild;
    storage.channels.addAll(guild.channels.list);

    dispatch(event: 'ServerCreateEvent', params: [guild]);
  }
}
