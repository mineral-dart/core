import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/events.dart';
import 'package:mineral/src/api/common/presence.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

final class GuildMemberChunkPacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.guildMemberChunk;

  MarshallerContract get _marshaller => ioc.resolve<MarshallerContract>();

  DataStoreContract get _dataStore => ioc.resolve<DataStoreContract>();

  WebsocketOrchestratorContract get _wss =>
      ioc.resolve<WebsocketOrchestratorContract>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final server = await _dataStore.server.get(
      message.payload['guild_id'],
      false,
    );

    final members = await List.from(
      message.payload['members'],
    ).map((element) async {
      final raw = await _marshaller.serializers.member.normalize({
        ...element,
        'guild_id': server.id.value,
      });

      return _marshaller.serializers.member.serialize(raw);
    }).wait;

    final presences = List<Map<String, dynamic>>.from(
      message.payload['presences'],
    ).map(Presence.fromJson).toList();

    final resolver = _wss.requestQueue.firstWhereOrNull(
      (element) => element.uid == message.payload['nonce'],
    );
    if (resolver != null && !resolver.completer.isCompleted) {
      if (resolver.targetKeys.length == 1 &&
          resolver.targetKeys.contains('presences')) {
        resolver.completer.complete(presences.first);
      }

      if (resolver.targetKeys.length == 1 &&
          resolver.targetKeys.contains('members')) {
        resolver.completer.complete(presences.first);
      }

      if (resolver.targetKeys.contains('members') &&
          resolver.targetKeys.contains('presences')) {
        resolver.completer
            .complete({'members': members, 'presences': presences});
      }

      _wss.requestQueue.remove(resolver);
    }

    dispatch(event: Event.serverMemberChunk, params: [server, members]);
  }
}
