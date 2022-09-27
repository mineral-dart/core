import 'package:http/http.dart';
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

/// Create your own service
/// Consider the following example :
/// We want to create a service that registers a message within a database via an API that will be contacted from our previously created HTTP service.

/// First, we will need to create our service as a class.
class NotifyService {
  Http http;
  NotifyService(this.http);

  Future<bool> write (String message, { String action = 'notify' }) async {
    Response response = await http.post(url: '/notify', payload: {
      'action': action,
      'message': message
    });

    return response.statusCode == 200;
  }
}

/// Now that our service is written, we will instantiate it in the framework IOC from the main file.
Future<void> main () async {
  Kernel kernel = Kernel()
    ..intents.defined(all: true)
    ..commands.register([HelloCommand()]);

  await kernel.init();

  Http http = Http(baseUrl: 'https://my-api');
  ioc.bind(namespace: 'NotifyService', service: NotifyService(http));
}

/// Now it's time to call our service! To do this we will imagine using a command directly within our discord server.
@Command(name: 'notify', description: 'Say Hello World !', scope: 'GUILD')
@Option(name: 'action', description: 'Action', type: OptionType.string, required: true)
@Option(name: 'message', description: 'Message to send', type: OptionType.string, required: true)
class HelloCommand extends MineralCommand {
  Future<void> handle (CommandInteraction interaction) async {
    final String? member = interaction.getString('action');
    final String? action = interaction.getString('action');

    final NotifyService service = ioc.singleton('NotifyService');
    await service.write('Hello World !', action: action ?? 'Notify');

    await interaction.reply(content: 'Hello $member !');
  }
}
