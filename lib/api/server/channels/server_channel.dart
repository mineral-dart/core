import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/server/server.dart';

abstract class ServerChannel extends Channel {
  late final Server guild;
  final int position;

  ServerChannel(String id, String name, this.position) : super(id, name);
}
