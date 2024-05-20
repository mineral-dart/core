import 'package:mineral/domains/events/event.dart';
import 'package:mineral/infrastructure/commons/listenable.dart';

abstract interface class ListenableEvent implements Listenable {
  Event get event;
}
