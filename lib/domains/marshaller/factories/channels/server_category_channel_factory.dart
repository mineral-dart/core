import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/channels/server_category_channel.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class ServerCategoryChannelFactory implements ChannelFactoryContract<ServerCategoryChannel> {
  @override
  ChannelType get type => ChannelType.guildCategory;

  @override
  Future<ServerCategoryChannel> make(MarshallerContract storage, String guildId, Map<String, dynamic> json) async {
    return ServerCategoryChannel.fromJson(guildId, json);
  }
}
