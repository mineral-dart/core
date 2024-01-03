import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/server/guild.dart';

abstract class GuildChannel extends Channel {
  int get position;
  Guild get guild;

  GuildChannel(super.id, super.name);
}
