enum InteractionType {
  ping(1),
  applicationCommand(2),
  messageComponent(3),
  applicationCommandAutocomplete(4),
  modal(5);

  final int value;
  const InteractionType(this.value);
}
