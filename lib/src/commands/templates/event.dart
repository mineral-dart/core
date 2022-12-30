final template = '''import 'package:mineral/framework.dart';
import 'package:mineral/core/events.dart';

class &ClassName extends MineralEvent<ReadyEvent> {
  Future<void> handle (event) async {
    // Your code here
  }
}''';