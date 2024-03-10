import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';

abstract interface class ChannelFactoryContract<T extends Channel> {
  ChannelType get type;
  Future<T> make(MarshallerContract marshaller, String guildId, Map<String, dynamic> json);
}
