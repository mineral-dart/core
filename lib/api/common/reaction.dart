import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/message.dart';

abstract class Reaction<T extends Message> {
  Emoji get emoji;
  int get count;
  Channel get channel;
  T get message;
  List<String> get burstColors;
  bool get burst;
}