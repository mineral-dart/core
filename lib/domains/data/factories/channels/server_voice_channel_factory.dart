import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_voice_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';

final class ServerVoiceChannelFactory implements ChannelFactoryContract<ServerVoiceChannel> {
  @override
  ChannelType get type => ChannelType.guildVoice;

  @override
  ServerVoiceChannel make(MemoryStorageContract storage, String guildId, Map<String, dynamic> json) {
    return ServerVoiceChannel.fromJson(guildId, json);
  }
}
