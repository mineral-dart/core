final class WebsocketResponse {
  final String? type;
  final int opCode;
  final int? sequence;
  final dynamic payload;

  WebsocketResponse({
    required this.type,
    required this.opCode,
    required this.sequence,
    required this.payload
  });

  factory WebsocketResponse.fromWebsocket(Map<String, dynamic> payload) {
    return WebsocketResponse(
      type: payload['t'],
      opCode: payload['op'],
      sequence: payload['s'],
      payload: payload['d']
    );
  }
}