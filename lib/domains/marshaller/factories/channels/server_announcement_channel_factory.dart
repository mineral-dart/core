import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_announcement_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class ServerAnnouncementChannelFactory implements ChannelFactoryContract<ServerAnnouncementChannel> {
  @override
  ChannelType get type => ChannelType.guildAnnouncement;

  @override
  Future<ServerAnnouncementChannel> make(MarshallerContract marshaller, String guildId, Map<String, dynamic> json) async {
    return ServerAnnouncementChannel.fromJson(guildId, json);
  }
}
