enum InteractionCallbackType {
  pong(1),
  channelMessageWithSource(4),
  deferredChannelMessageWithSource(5),
  deferredUpdateMessage(6),
  updateMessage(7),
  applicationCommandAutocompleteResult(8),
  modal(9),
  premiumRequired(10);

  final int value;
  const InteractionCallbackType(this.value);
}