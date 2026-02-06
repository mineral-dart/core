/// Discord Voice Gateway Op Codes
///
/// See: https://discord.com/developers/docs/topics/voice-connections#voice-events
enum VoiceOpCode {
  /// Client -> Server: Begin a voice websocket connection
  identify(0),

  /// Client -> Server: Select the voice protocol
  selectProtocol(1),

  /// Server -> Client: Complete the websocket handshake
  ready(2),

  /// Client -> Server: Keep the websocket connection alive
  heartbeat(3),

  /// Server -> Client: Describe the session
  sessionDescription(4),

  /// Bidirectional: Indicate which users are speaking
  speaking(5),

  /// Server -> Client: Heartbeat acknowledgement
  heartbeatAck(6),

  /// Client -> Server: Resume a connection
  resume(7),

  /// Server -> Client: Hello, contains heartbeat interval
  hello(8),

  /// Server -> Client: Acknowledge resume
  resumed(9),

  /// Server -> Client: A client has disconnected from the voice channel
  clientDisconnect(13);

  final int value;
  const VoiceOpCode(this.value);

  static VoiceOpCode? fromValue(int value) {
    for (final op in values) {
      if (op.value == value) return op;
    }
    return null;
  }
}
