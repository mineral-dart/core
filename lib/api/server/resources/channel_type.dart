enum ChannelsType {
  guildText(0),
  dm(1),
  guildVoice(2),
  groupDm(3),
  guildCategory(4),
  guildNews(5),
  newsThread(10),
  publicThread(11),
  privateThread(12),
  guildStageVoice(13),
  guildDirectory(14),
  guildForum(15),
  guildMedia(16);

  final int value;
  const ChannelsType(this.value);
}