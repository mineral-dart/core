import 'package:mineral/api/common/snowflake.dart';

abstract class Channel {
  final Snowflake id;
  final String name;

  const Channel(this.id, this.name);
}
