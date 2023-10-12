import 'package:mineral/api/common/snowflake.dart';

abstract interface class ApplicationContract {
  abstract final Snowflake id;
  abstract final int flags;
}