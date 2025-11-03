import 'package:mineral/src/domains/common/utils/listenable.dart';

abstract interface class GlobalState<T> implements Listenable {
  T get state;
}
