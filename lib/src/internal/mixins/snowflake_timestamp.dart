import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';

extension SnowflakeTimestamp on Snowflake {
  DateTime get dateTime {
    int timestamp = (int.parse(this) >> 22) + Constants.discordEpoch;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }
}
