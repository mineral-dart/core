enum DefaultMessageNotification {
  allMessages(0),
  onlyMentions(1);

  final int value;
  const DefaultMessageNotification(this.value);
}
