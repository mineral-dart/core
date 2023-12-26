import 'dart:async';

abstract interface class Listenable {
  StreamSubscription listen(void Function(dynamic) handle);

  void dispatch(dynamic payload);

  void dispose();
}
