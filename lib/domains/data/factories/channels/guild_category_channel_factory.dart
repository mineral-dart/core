import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/guild_category_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class GuildCategoryChannelFactory implements ChannelFactoryContract<GuildCategoryChannel> {
  @override
  ChannelType get type => ChannelType.guildCategory;

  @override
  GuildCategoryChannel make(String guildId, Map<String, dynamic> json) {
    return GuildCategoryChannel.fromJson(guildId, json);
  }
}
