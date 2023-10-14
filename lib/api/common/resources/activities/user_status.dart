enum UserStatus {
  offline('offline'),
  online('online'),
  idle('idle'),
  invisible('invisible'),
  doNotDisturb('dnd');

  final String value;

  const UserStatus(this.value);
}