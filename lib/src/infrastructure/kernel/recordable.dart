import 'package:mineral/src/infrastructure/kernel/kernel.dart';

abstract interface class RecordableDispatcher<T> {
  Type get match;
  void dispatch<R>(KernelContract kernel, T instance);
}
