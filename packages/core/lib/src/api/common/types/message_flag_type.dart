enum MessageFlagType {
  none(0),
  crossPosted(1 << 1),
  suppressEmbeds(1 << 2),
  sourceMessageDeleted(1 << 3),
  urgent(1 << 4),
  thread(1 << 5),
  ephemeral(1 << 6),
  loading(1 << 7),
  failedToMentionSomeRoleInThread(1 << 8),
  suppressNotifications(1 << 12),
  voiceMessage(1 << 13),
  hasSnapshot(1 << 14),
  isComponentV2(1 << 15);

  final int value;
  const MessageFlagType(this.value);
}
