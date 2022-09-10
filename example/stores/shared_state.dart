import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';

@Store('my-store')
class MyStore<T extends String> extends MineralStore {
  List<T> state = [];

  // Add string to this
  void addItem (T value) => state.add(value);

  // Verify if this contains given value
  bool has (T value) => state.contains(value);
}

/// Register our store into the main.dart
Future<void> main () async {
  Kernel kernel = Kernel()
    ..stores.register([MyStore()]);

  await kernel.init();
}

/// Consume the store
@Event(Events.messageCreate)
class MessageCreate extends MineralEvent {
  Future<void> handle (Message message) async {
    final store = stores.getStore<MyStore>('my-store');
    store.addItem('Hello World !');

    Console.info(message: 'MyStore contains ${store.state.length} items.');
  }
}
