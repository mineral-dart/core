import 'package:mineral/src/api/common/message.dart';
import 'package:mineral/src/api/common/snowflake.dart';

final class MessageManager<T extends Message> {
  final Map<Snowflake, T> list = {};
}
