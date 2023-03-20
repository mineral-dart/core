enum ButtonStyle {
  primary(1),
  secondary(2),
  success(3),
  danger(4),
  link(5);

  final int value;
  const ButtonStyle(this.value);

  @override
  String toString () => value.toString();
}