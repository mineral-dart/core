import 'dart:async';

import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';

abstract interface class ChannelFactoryContract<T extends Channel> {
  ChannelType get type;
  FutureOr<Map<String, dynamic>> normalize(MarshallerContract marshaller, Map<String, dynamic> json);
  FutureOr<T> serialize(MarshallerContract marshaller, Map<String, dynamic> json);
  FutureOr<Map<String, dynamic>> deserialize(MarshallerContract marshaller, T channel);
}
