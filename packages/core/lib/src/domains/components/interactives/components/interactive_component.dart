import 'package:mineral/src/domains/common/utils/listenable.dart';

abstract interface class InteractiveComponent<T> implements Listenable {
  String get customId;

  T build();
}
