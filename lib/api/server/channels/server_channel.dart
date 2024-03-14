import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/snowflake.dart';
import 'package:mineral/api/common/types/channel_type.dart';
import 'package:mineral/api/server/server.dart';

abstract class ServerChannel extends Channel {
  late final Server server;
  final int position;

  ServerChannel(Snowflake id, ChannelType type, String name, this.position) : super(id, type, name);
}
