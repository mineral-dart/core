import 'package:mineral/core/builders.dart';

class Md {
  Md._();

  /// Returns a bold text
  /// ```dart
  /// final str = Md.bold('Hello world');
  /// ```
  static String bold (dynamic value) => '**$value**';

  /// Returns a underline text
  /// ```dart
  /// final str = Md.underline('Hello world');
  /// ```
  static String underline (dynamic value) => '__${value}__';

  /// Returns a strikethrough text
  /// ```dart
  /// final str = Md.strikethrough('Hello world');
  /// ```
  static String strikethrough (dynamic value) => '~~$value~~';

  /// Returns a code text
  /// ```dart
  /// final str = Md.code('Hello world');
  /// ```
  static String code (String value) => '```$value```';

  /// Returns a inline code text
  /// ```dart
  /// final str = Md.inlineCode('Hello world');
  /// ```
  static String italic (String value) => '*$value*';

  /// Returns a spoil code text
  /// ```dart
  /// final str = Md.spoil('Hello world');
  /// ```
  static String spoil (dynamic value) => '||$value||';

  /// Returns a timestamp text
  /// ```dart
  /// final str = Md.timestamp(DateTime.now());
  /// ```
  static String timestamp (DateTime value, { TimestampStyle? style }) => style != null
    ? '<t:${(value.millisecondsSinceEpoch / 1000).round()}:${style.value}>'
    : '<t:${(value.millisecondsSinceEpoch / 1000).round()}>';
}