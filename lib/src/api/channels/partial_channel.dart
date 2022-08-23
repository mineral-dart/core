import 'package:mineral/api.dart';

enum ChannelType {
  guildText(0),
  private(1),
  guildVoice(2),
  groupDm(3),
  guildCategory(4),
  guildNews(5),
  guildNewsThread(10),
  guildPublicThread(11),
  guildPrivateThread(12),
  guildStageVoice(13),
  guildDirectory(14),
  guildForum(15);

  final int value;
  const ChannelType(this.value);
}

class PartialChannel {
  final Snowflake _id;

  PartialChannel(this._id);

  Snowflake get id => _id;
}
