enum Permission {
  createInstantInvite(1 << 0),
  kickMembers(1 << 1),
  banMembers(1 << 2),
  administrator(1 << 3),
  manageChannels(1 << 4),
  manageGuilds(1 << 5),
  addReactions(1 << 6),
  viewAuditChannel(1 << 7),
  prioritySpeaker(1 << 8),
  stream(1 << 9),
  viewChannel(1 << 10),
  sendMessages(1 << 11),
  sendTtsMessage(1 << 12),
  manageMessages(1 << 13),
  embedLinks(1 << 14),
  attachFiles(1 << 15),
  readMessageHistory(1 << 16),
  mentionEveryone(1 << 17),
  useExternalEmojis(1 << 18),
  viewGuildInsights(1 << 19),
  connect(1 << 20),
  speak(1 << 21),
  muteMembers(1 << 22),
  deafenMembers(1 << 23),
  moveMembers(1 << 24),
  useVad(1 << 25),
  changeUsername(1 << 26),
  managerUsernames(1 << 27),
  manageRoles(1 << 28),
  manageWebhooks(1 << 29),
  manageEmojisAndStickers(1 << 30),
  useApplicationCommand(1 << 31),
  requestToSpeak(1 << 32),
  manageEvents(1 << 33),
  manageThreads(1 << 34),
  usePublicThreads(1 << 35),
  createPublicThreads(1 << 35),
  usePrivateThreads(1 << 36),
  createPrivateThreads(1 << 36),
  useExternalStickers(1 << 37),
  sendMessageInThreads(1 << 38),
  startEmbeddedActivities(1 << 39),
  moderateMembers(1 << 40);

  final int value;
  const Permission(this.value);

  static Permission from(final int value) {
    for (final Permission permission in Permission.values) {
      if (permission.value == value) {
        return permission;
      }
    }
    throw ArgumentError('Unknown permission: $value');
  }
}