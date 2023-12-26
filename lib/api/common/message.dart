import 'package:mineral/api/common/channel.dart';

abstract interface class Message {
  String get id;
  String get content;
  String get createdAt;
  String get updatedAt;
  String get channelId;
  Channel get channel;
}
