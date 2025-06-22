import 'package:mineral/src/domains/commons/kernel.dart';

abstract interface class RecordableDispatcher<T> {
  Type get match;
  void dispatch<R>(Kernel kernel, T instance);
}
