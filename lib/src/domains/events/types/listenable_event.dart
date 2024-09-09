import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/infrastructure/commons/listenable.dart';

abstract interface class ListenableEvent implements Listenable {
  Event get event;
  String? get customId;
}
