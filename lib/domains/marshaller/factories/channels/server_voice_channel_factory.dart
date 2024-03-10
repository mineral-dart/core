import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_voice_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class ServerVoiceChannelFactory implements ChannelFactoryContract<ServerVoiceChannel> {
  @override
  ChannelType get type => ChannelType.guildVoice;

  @override
  Future<ServerVoiceChannel> make(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    return ServerVoiceChannel.fromJson(guildId, json);
  }
}
