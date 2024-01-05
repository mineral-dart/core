import 'package:mineral/api/common/channel.dart';

abstract class Message<T extends Channel> {
  final String id;
  final String content;
  final T channel;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Message(
    this.id,
    this.content,
    this.channel,
    this.createdAt,
    this.updatedAt,
  );
}
