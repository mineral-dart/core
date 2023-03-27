enum TimestampStyle {
  shortTime('t'),
  longTime('T'),
  shortDate('d'),
  longDate('D'),
  shortDateTime('f*'),
  longDateTime('F'),
  relativeTime('R');

  final String value;
  const TimestampStyle(this.value);
}