enum CommandType {
  command(0),
  subcommand(1),
  group(2);

  final int type;
  const CommandType(this.type);
}