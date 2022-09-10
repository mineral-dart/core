## Define our store
```dart
import 'package:mineral/core.dart';

@Store(name: 'my-store')
class MyStore extends MineralStore<T extends String> {
  List<T> state = [];
  
  // Add string to this
  void addItem (T value) => state.add(value);
  
  // Verify if this contains given value
  bool has (T value) => state.contains(value);
}     
```

## Register our store
```dart
Future<void> main () async {
  Kernel kernel = Kernel()
    ..stores.register([MyStore()]); 👈

  await kernel.init();
}
```

## Consume our store
```dart
@Event(Events.messageCreate)
class MessageCreate {
  Future<void> handle (Message message) async {
    final store = stores.getStore<MyStore>('my-store');
    store.addItem('Hello World !');

    Console.info(message: 'MyStore contains ${store.state.length} items.');
  }
}
```
