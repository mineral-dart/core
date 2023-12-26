import 'dart:async';

abstract interface class Listenable<T> {
  StreamSubscription listen(void Function(T) handle);

  void dispatch(T payload);

  void dispose();
}
