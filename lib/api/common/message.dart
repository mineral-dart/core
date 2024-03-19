import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/snowflake.dart';

abstract class Message {
  Snowflake get id;
  String? get content;
}
