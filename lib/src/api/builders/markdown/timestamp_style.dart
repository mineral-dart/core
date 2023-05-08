/// Defines the style of the timestamp.
enum TimestampStyle {
  /// Short time style
  shortTime('t'),

  /// Long time style
  longTime('T'),

  /// Short date style
  shortDate('d'),

  /// Long date style
  longDate('D'),

  /// Short date time style
  shortDateTime('f*'),

  /// Long date time style
  longDateTime('F'),

  /// Relative time style
  relativeTime('R');

  final String value;
  const TimestampStyle(this.value);
}