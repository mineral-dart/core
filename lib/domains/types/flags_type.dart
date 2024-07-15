enum FlagsType {
  none(0),
  ephemeral(64);

  final int value;
  const FlagsType(this.value);
}