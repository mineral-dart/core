import 'dart:async';

abstract interface class ListenableDispatcher<T> {
  StreamSubscription listen(void Function(T) handle);

  void dispatch(T payload);

  void dispose();
}
