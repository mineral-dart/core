import 'package:mineral/framework.dart';

class ResumedEvent extends Event {
  final Map<String, dynamic> payload;
  ResumedEvent(this.payload);
}