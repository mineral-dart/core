import 'package:mineral/api/common/message.dart';
import 'package:mineral/api/common/snowflake.dart';

final class MessageManager<T extends Message> {
  final Map<Snowflake, T> list = {};
}
