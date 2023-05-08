import 'package:mineral/core/builders.dart';

/// Style of [ButtonBuilder]
enum ButtonStyle {
  /// Primary style
  primary(1),

  /// Secondary style
  secondary(2),

  /// Success style
  success(3),

  /// Danger style
  danger(4),

  /// Link style
  link(5);

  final int value;
  const ButtonStyle(this.value);
}