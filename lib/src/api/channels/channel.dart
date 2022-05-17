import 'package:mineral/src/constants.dart';

class ChannelType {
  static int guildText = 0;
  static int private = 1;
  static int guildVoice = 2;
  static int groupDm = 3;
  static int guildCategory = 4;
  static int guildNews = 5;
  static int guildNewsThread = 10;
  static int guildPublicThread = 11;
  static int guildPrivateThread = 12;
  static int guildStageVoice = 13;
  static int guildDirectory = 14;
  static int guildForum = 15;
}

class Channel {
  Snowflake id;
  int type;
  Snowflake? guildId;
  int? position;
  String? label;
  Snowflake? applicationId;
  Snowflake? parentId;
  int? flags;

  Channel({
    required this.id,
    required this.type,
    required this.guildId,
    required this.position,
    required this.label,
    required this.applicationId,
    required this.parentId,
    required this.flags,
  });
}
