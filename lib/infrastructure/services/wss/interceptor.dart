import 'package:mineral/infrastructure/services/wss/websocket_message.dart';
import 'package:mineral/infrastructure/services/wss/websocket_requested_message.dart';

typedef MessageInterceptor = Future<WebsocketMessage> Function(WebsocketMessage);
typedef RequestInterceptor = Future<WebsocketRequestedMessage> Function(WebsocketRequestedMessage);

abstract interface class Interceptor {
  List<MessageInterceptor> get message;
  List<RequestInterceptor> get request;
}

final class InterceptorImpl implements Interceptor {
  @override
  final List<MessageInterceptor> message = [];

  @override
  final List<RequestInterceptor> request = [];
}
