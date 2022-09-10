import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

@Command(name: 'simple-command', description: 'Simple command description', scope: 'GUILD', everyone: true)
class SimpleCommand extends MineralCommand {
  Future<void> handle (CommandInteraction interaction) async {
    await interaction.reply(
      content: 'Hello World !',
      private: true
    );
  }
}
