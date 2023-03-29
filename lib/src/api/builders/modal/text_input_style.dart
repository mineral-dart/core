enum TextInputStyle {
  input(1),
  paragraph(2);

  final int value;
  const TextInputStyle(this.value);

  @override
  String toString () => value.toString();
}