/// Represents the state of a voice connection
enum VoiceConnectionState {
  /// Not connected to any voice channel
  disconnected,

  /// Connecting to the voice gateway
  connecting,

  /// Sent identify, waiting for ready
  identifying,

  /// Performing UDP setup and IP discovery
  udpSetup,

  /// Sent select protocol, waiting for session description
  selectingProtocol,

  /// Fully connected and ready to send/receive audio
  ready,

  /// Attempting to reconnect after a disconnect
  reconnecting,
}
