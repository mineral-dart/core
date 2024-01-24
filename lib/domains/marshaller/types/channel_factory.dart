import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/domains/marshaller/memory_storage.dart';

abstract interface class ChannelFactoryContract<T extends Channel> {
  ChannelType get type;
  T make(MemoryStorageContract storage, String guildId, Map<String, dynamic> json);
}
