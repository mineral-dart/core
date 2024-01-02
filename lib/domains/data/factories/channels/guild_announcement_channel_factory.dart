import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/guild_announcement_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class GuildAnnouncementChannelFactory implements ChannelFactoryContract<GuildAnnouncementChannel> {
  @override
  ChannelType get type => ChannelType.guildAnnouncement;

  @override
  GuildAnnouncementChannel make(String guildId, Map<String, dynamic> json) {
    return GuildAnnouncementChannel.fromJson(guildId, json);
  }
}
