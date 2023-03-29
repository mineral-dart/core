import 'package:mineral/core/builders.dart';

class Md {
  Md._();

  static String bold (dynamic value) => '**$value**';

  static String underline (dynamic value) => '__${value}__';

  static String strikethrough (dynamic value) => '~~$value~~';

  static String code (String value) => '```$value```';

  static String italic (String value) => '*$value*';

  static String spoil (dynamic value) => '||$value||';

  static String timestamp (DateTime value, { TimestampStyle? style }) => style != null
    ? '<t:${(value.millisecondsSinceEpoch / 1000).round()}:${style.value}>'
    : '<t:${(value.millisecondsSinceEpoch / 1000).round()}>';
}