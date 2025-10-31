import 'dart:async';
import 'dart:io' as io;

import 'package:mineral/src/infrastructure/services/wss/interceptor.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_requested_message.dart';

abstract interface class WebsocketClient {
  String get name;
  String get url;
  Stream? get stream;
  Interceptor get interceptor;
  Future<void> connect();
  void disconnect({int? code, String? reason});
  Future<void> send(String message);
  Future<void> listen(void Function(WebsocketMessage) callback);
}

final class WebsocketClientImpl implements WebsocketClient {
  io.WebSocket? _channel;
  StreamSubscription<dynamic>? _channelListener;
  final void Function(Object payload)? _onError;
  final void Function(int? exitCode)? _onClose;
  final void Function(WebsocketMessage)? _onOpen;
  void Function(WebsocketMessage)? _onMessage;

  @override
  final Interceptor interceptor = InterceptorImpl();

  @override
  final String name;

  @override
  final String url;

  @override
  Stream? stream;

  WebsocketClientImpl({
    required this.url,
    this.name = 'default',
    void Function(Object payload)? onError,
    void Function(int? exitCode)? onClose,
    void Function(WebsocketMessage)? onOpen,
  })  : _onError = onError,
        _onClose = onClose,
        _onOpen = onOpen;

  @override
  Future<void> connect() async {
    try {
      _channel = await io.WebSocket.connect(url);
      stream = _channel!.asBroadcastStream();

      if (_onError != null) {
        stream!.handleError((err) {
          _onError({
            'error': err,
            'code': _channel?.closeCode,
            'reason': _channel?.closeReason
          });
        });
      }

      _channelListener = stream!.listen(
        (dynamic message) => _handleMessage(_onMessage, message),
        onDone: () {
          _onClose!(_channel!.closeCode);
        },
      );

      if (_onOpen != null) {
        final firstMessage = await stream?.first;
        _handleMessage(_onOpen, firstMessage);
      }
    } on io.WebSocketException catch (err) {
      print(err);
      _onError!({
        'error': err,
        'code': _channel?.closeCode,
        'reason': _channel?.closeReason
      });
    }
  }

  @override
  void disconnect({int? code = 4000, String? reason}) {
    _channelListener?.cancel();
    _channel?.close(code, reason);
  }

  @override
  Future<void> listen(void Function(WebsocketMessage) callback) async {
    _onMessage = callback;
  }

  Future<void> _handleMessage(callback, dynamic message) async {
    final interceptedMessage = await _handleMessageInterceptors(
      WebsocketMessageImpl(
        channelName: name,
        originalContent: message,
        content: message,
      ),
    );

    callback(interceptedMessage);
  }

  @override
  Future<void> send(String message) async {
    final interceptedMessage = await _handleRequestedMessageInterceptors(
      WebsocketRequestedMessageImpl(channelName: name, content: message),
    );

    switch (_channel?.readyState) {
      case io.WebSocket.open:
        _channel?.add(interceptedMessage.content);
      case io.WebSocket.closed when _onClose != null:
        _onClose(_channel!.closeCode!);
    }
  }

  Future<WebsocketMessage> _handleMessageInterceptors(
    WebsocketMessage message,
  ) async {
    for (final interceptor in interceptor.message) {
      message = await interceptor(message);
    }

    return message;
  }

  Future<WebsocketRequestedMessage> _handleRequestedMessageInterceptors(
    WebsocketRequestedMessage message,
  ) async {
    for (final interceptor in interceptor.request) {
      message = await interceptor(message);
    }

    return message;
  }
}
