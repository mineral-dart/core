import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/domains/data/factories/channel_factory.dart';

final class ServerCategoryChannelFactory implements ChannelFactoryContract<ServerCategoryChannel> {
  @override
  ChannelType get type => ChannelType.guildCategory;

  @override
  ServerCategoryChannel make(String guildId, Map<String, dynamic> json) {
    return ServerCategoryChannel.fromJson(guildId, json);
  }
}
