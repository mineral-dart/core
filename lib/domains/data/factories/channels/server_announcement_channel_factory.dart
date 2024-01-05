import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class ServerAnnouncementChannelFactory implements ChannelFactoryContract<ServerAnnouncementChannel> {
  @override
  ChannelType get type => ChannelType.guildAnnouncement;

  @override
  ServerAnnouncementChannel make(String guildId, Map<String, dynamic> json) {
    return ServerAnnouncementChannel.fromJson(guildId, json);
  }
}
