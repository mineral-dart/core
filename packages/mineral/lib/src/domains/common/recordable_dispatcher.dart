import 'package:mineral/src/domains/common/kernel.dart';

abstract interface class RecordableDispatcher<T> {
  Type get match;
  void dispatch<R>(Kernel kernel, T instance);
}
