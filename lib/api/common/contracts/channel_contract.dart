import 'package:mineral/api/common/snowflake.dart';

abstract interface class ChannelContract {
  abstract final Snowflake id;
  abstract final String name;
}