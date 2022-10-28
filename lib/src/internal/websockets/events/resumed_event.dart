import 'package:mineral/event.dart';

class ResumedEvent extends Event {
  final Map<String, dynamic> payload;
  ResumedEvent(this.payload);
}