import 'package:mineral/src/api/builders/modal/input_builder.dart';

/// The style of the [InputBuilder].
enum TextInputStyle {
  /// A single line text input.
  input(1),

  /// A multiline text input.
  paragraph(2);

  final int value;
  const TextInputStyle(this.value);
}