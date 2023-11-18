import 'dart:io' as io;

import 'package:mineral/api/wss/interceptor.dart';
import 'package:mineral/api/wss/websocket_message.dart';
import 'package:mineral/api/wss/websocket_requested_message.dart';

abstract interface class WebsocketClient {
  String get name;

  String get url;

  Stream get stream;

  Interceptor get interceptor;

  Future<void> connect();

  void disconnect({int? code, String? reason});

  Future<void> send(String message);

  Future<void> listen(void Function(WebsocketMessage) callback);
}

final class WebsocketClientImpl implements WebsocketClient {
  late final io.WebSocket _channel;
  final void Function(dynamic)? _onError;
  final void Function()? _onClose;
  final void Function(WebsocketMessage)? _onOpen;
  void Function(WebsocketMessage)? _onMessage;

  @override
  final Interceptor interceptor = InterceptorImpl();

  @override
  final String name;

  @override
  final String url;

  @override
  late final Stream stream;

  WebsocketClientImpl(
      {required this.url,
      this.name = 'default',
      void Function(dynamic)? onError,
      void Function()? onClose,
      void Function(WebsocketMessage)? onOpen})
      : _onError = onError,
        _onClose = onClose,
        _onOpen = onOpen;

  @override
  Future<void> connect() async {
    _channel = await io.WebSocket.connect(url);
    stream = _channel.asBroadcastStream();

    stream.listen(
      (dynamic message) => _handleMessage(_onMessage, message),
      onError: _onError,
      onDone: _onClose,
    );

    final firstMessage = await stream.first;
    _handleMessage(_onOpen?.call, firstMessage);
  }

  @override
  void disconnect({int? code = 1000, String? reason}) {
    _channel.close(code, reason);
  }

  @override
  Future<void> listen(void Function(WebsocketMessage) callback) async {
    _onMessage = callback;
  }

  Future<void> _handleMessage(callback, dynamic message) async {
    final interceptedMessage = await _handleMessageInterceptors(WebsocketMessageImpl(
        channelName: name, originalContent: message, content: message.toString()));

    callback(interceptedMessage);
  }

  @override
  Future<void> send(String message) async {
    final interceptedMessage = await _handleRequestedMessageInterceptors(
        WebsocketRequestedMessageImpl(channelName: name, content: message));
    _channel.add(interceptedMessage.content);
  }

  Future<WebsocketMessage> _handleMessageInterceptors(WebsocketMessage message) async {
    for (final interceptor in interceptor.message) {
      message = await interceptor(message);
    }

    return message;
  }

  Future<WebsocketRequestedMessage> _handleRequestedMessageInterceptors(
      WebsocketRequestedMessage message) async {
    for (final interceptor in interceptor.request) {
      message = await interceptor(message);
    }

    return message;
  }
}
