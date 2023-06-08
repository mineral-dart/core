class CommandScope {
  final String mode;

  static CommandScope get guild => CommandScope('GUILD');
  static CommandScope get global => CommandScope('GLOBAL');

  bool get isGlobal => mode == 'GLOBAL';
  bool get isGuild => !isGlobal;

  CommandScope(this.mode);
}