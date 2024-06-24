enum CommandContext {
  guild(0),
  global(1);

  final int value;
  const CommandContext(this.value);
}