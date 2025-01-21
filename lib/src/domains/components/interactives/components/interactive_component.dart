import 'dart:async';

import 'package:mineral/src/domains/commons/utils/listenable.dart';

abstract interface class InteractiveComponent<T> implements Listenable {
  String get customId;

  T build();
}
