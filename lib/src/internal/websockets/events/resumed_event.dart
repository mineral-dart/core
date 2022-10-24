import 'package:mineral/event.dart';

class ResumedEvent extends Event {
  final String payload;
  ResumedEvent(this.payload);
}