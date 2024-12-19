abstract interface class HmrContract {
  void send(Map payload);
  Future<void> spawn();
}
