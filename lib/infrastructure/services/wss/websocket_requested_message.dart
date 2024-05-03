abstract interface class WebsocketRequestedMessage {
  DateTime get createdAt;

  String get channelName;

  String get content;
}

final class WebsocketRequestedMessageImpl implements WebsocketRequestedMessage {
  @override
  final DateTime createdAt = DateTime.now();

  @override
  final String channelName;

  @override
  final String content;

  WebsocketRequestedMessageImpl({required this.channelName, required this.content});
}
