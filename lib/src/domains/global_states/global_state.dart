import 'package:mineral/src/infrastructure/commons/listenable.dart';

abstract interface class GlobalState<T> implements Listenable {
  T get state;
}
