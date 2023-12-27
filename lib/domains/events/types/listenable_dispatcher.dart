abstract interface class ListenableDispatcher {
  void listen(dynamic params);

  void dispatch(dynamic payload);

  void dispose();
}
