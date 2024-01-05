import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_forum_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class ServerForumChannelFactory implements ChannelFactoryContract<ServerForumChannel> {
  @override
  ChannelType get type => ChannelType.guildForum;

  @override
  ServerForumChannel make(String guildId, Map<String, dynamic> json) {
    return ServerForumChannel.fromJson(guildId, json);
  }
}
