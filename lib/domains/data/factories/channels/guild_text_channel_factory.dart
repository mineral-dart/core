import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/guild_text_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class GuildTextChannelFactory implements ChannelFactoryContract<GuildTextChannel> {
  @override
  ChannelType get type => ChannelType.guildText;

  @override
  GuildTextChannel make(String guildId, Map<String, dynamic> json) {
    return GuildTextChannel.fromJson(guildId, json);
  }
}
