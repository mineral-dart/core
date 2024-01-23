import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/domains/data/memory/memory_storage.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class ServerCategoryChannelFactory implements ChannelFactoryContract<ServerCategoryChannel> {
  @override
  ChannelType get type => ChannelType.guildCategory;

  @override
  ServerCategoryChannel make(MemoryStorageContract storage, String guildId, Map<String, dynamic> json) {
    return ServerCategoryChannel.fromJson(guildId, json);
  }
}
