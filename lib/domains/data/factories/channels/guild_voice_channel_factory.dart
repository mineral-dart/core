import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/guild_voice_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class GuildVoiceChannelFactory implements ChannelFactoryContract<GuildVoiceChannel> {
  @override
  ChannelType get type => ChannelType.guildVoice;

  @override
  GuildVoiceChannel make(String guildId, Map<String, dynamic> json) {
    return GuildVoiceChannel.fromJson(guildId, json);
  }
}
