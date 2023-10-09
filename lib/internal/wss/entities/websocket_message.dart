import 'package:mineral/internal/wss/op_code.dart';

final class WebsocketMessage {
  final OpCode code;
  final dynamic payload;

  WebsocketMessage(this.code, this.payload);

  Map<String, dynamic> build () => {
    'op': code.value,
    'd': payload
  };
}