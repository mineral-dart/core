# Create your own service

Consider the following example :

We want to create a service that registers a message within a database via an API that will be contacted from our previously created HTTP service.

First, we will need to create our service as a class.

```dart
class NotifyService {
  Http http;
  NotifyService(this.http);
  
  Future<bool> write (String message, { String action = 'notify' }) async {
    Response response = await http.post('/notify', {
      'action': action,
      'message': message
    });
    
    return response.statusCode == 200;
  }
}
```

Now that our service is written, we will instantiate it in the framework IOC from the main file.
```dart
Future<void> main () async {
  Kernel kernel = Kernel()
  ..intents.defined(all: true)
  ..commands([MyCommand()]);
  
  await kernel.init();

  Http http = Http(baseUrl: 'https://my-api');
  ioc.bind('NotifyService', NotifyService(http));
}
```

Now it's time to call our service! To do this we will imagine using a command directly within our discord server.

```dart
@Command(label: 'notify', description: 'Say Hello World !', scope: 'GUILD')
@Option(label: 'action', description: 'Action', required: true)
@Option(label: 'message', description: 'Message to send', required: true)
class HelloCommand extends MineralCommand {
  Future<void> handle (CommandInteraction interaction) async {
    final String? member = interaction.data.getString('action');
    final String? member = interaction.data.getString('action');
    
    final NotifyService service = ioc.singleton('NotifyService');
    await service.write('Hello World !');
  
    await interaction.reply(content: 'Hello $member !');
  }
}
```
