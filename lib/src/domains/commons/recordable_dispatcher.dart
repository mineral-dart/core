import 'package:mineral/src/domains/commons/kernel.dart';

abstract interface class RecordableDispatcher<T> {
  Type get match;
  void dispatch<R>(KernelContract kernel, T instance);
}
