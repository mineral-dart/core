import 'package:mineral/src/domains/commons/utils/listenable.dart';

abstract interface class GlobalState<T> implements Listenable {
  T get state;
}
