abstract interface class ListenableDispatcher<T> {
  void listen(dynamic params);
  void dispatch(T payload);
  void dispose();
}
