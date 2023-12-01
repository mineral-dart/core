import 'package:mineral/api/api/common/channel.dart';
import 'package:mineral/api/api/server/guild.dart';

abstract interface class GuildChannel implements Channel {
  int get position;
  String get guildId;
  Guild get guild;
}
