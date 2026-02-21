abstract interface class ShardAuthenticationContract {
  void setupRequirements(Map<String, dynamic> payload);

  void identify(Map<String, dynamic> payload);

  Future<void> connect();

  Future<void> reconnect();

  void heartbeat();

  void ack();

  Future<void> resume();
}
