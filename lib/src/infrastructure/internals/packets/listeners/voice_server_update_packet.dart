import 'package:mineral/api.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/infrastructure/internals/voice/voice_connection_manager.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';

/// Handles the VOICE_SERVER_UPDATE Discord gateway event.
///
/// This event provides the endpoint and token needed to connect to
/// Discord's voice server after requesting to join a voice channel.
final class VoiceServerUpdatePacket implements ListenablePacket {
  @override
  PacketType get packetType => PacketType.voiceServerUpdate;

  VoiceConnectionManager get _voiceManager =>
      ioc.resolve<VoiceConnectionManager>();

  @override
  Future<void> listen(ShardMessage message, DispatchEvent dispatch) async {
    final payload = message.payload;

    final serverId = Snowflake.parse(payload['guild_id']);
    final token = payload['token'] as String?;
    final endpoint = payload['endpoint'] as String?;

    if (token == null) {
      // This shouldn't happen but handle it gracefully
      return;
    }

    await _voiceManager.handleServerUpdate(
      serverId: serverId,
      token: token,
      endpoint: endpoint,
    );
  }
}
