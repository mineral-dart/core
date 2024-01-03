import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/server/guild.dart';

abstract class GuildChannel extends Channel {
  late final Guild guild;
  final int position;

  GuildChannel(String id, String name, this.position) : super(id, name);
}
