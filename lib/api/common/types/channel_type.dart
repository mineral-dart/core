import 'package:mineral/api/common/types/enhanced_enum.dart';

enum ChannelType implements EnhancedEnum<int>{
  guildText(0),
  dm(1),
  guildVoice(2),
  groupDm(3),
  guildCategory(4),
  guildAnnouncement(5),
  announcementThread(10),
  guildPublicThread(11),
  guildPrivateThread(12),
  guildStageVoice(13),
  guildDirectory(14),
  guildForum(15),
  guildMedia(16);

  final int value;
  const ChannelType(this.value);
}
