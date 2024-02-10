import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/private/channels/private_channel.dart';
import 'package:mineral/domains/marshaller/memory_storage.dart';
import 'package:mineral/domains/marshaller/types/channel_factory.dart';

final class PrivateChannelFactory implements ChannelFactoryContract<PrivateChannel> {
  @override
  ChannelType get type => ChannelType.dm;

  @override
  PrivateChannel make(MemoryStorageContract storage, String guildId, Map<String, dynamic> json) {
    return PrivateChannel.fromJson(json);
  }
}
