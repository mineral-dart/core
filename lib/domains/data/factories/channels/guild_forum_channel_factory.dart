import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/guild_forum_channel.dart';
import 'package:mineral/api/server/channels/guild_text_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class GuildForumChannelFactory implements ChannelFactoryContract<GuildForumChannel> {
  @override
  ChannelType get type => ChannelType.guildForum;

  @override
  GuildForumChannel make(String guildId, Map<String, dynamic> json) {
    return GuildForumChannel.fromJson(guildId, json);
  }
}
