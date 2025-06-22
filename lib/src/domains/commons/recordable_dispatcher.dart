import 'package:mineral/src/domains/services/kernel.dart';

abstract interface class RecordableDispatcher<T> {
  Type get match;
  void dispatch<R>(KernelContract kernel, T instance);
}
