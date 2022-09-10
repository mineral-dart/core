import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

@Command(name: 'command', description: 'Command with subcommands', scope: 'GUILD', everyone: true)
class SimpleCommand extends MineralCommand {
  @Subcommand(name: 'first-subcommand', description: 'First subcommand description', bind: 'first')
  Future<void> first (CommandInteraction interaction) async {
    await interaction.reply(
      content: 'Hello World !',
      private: true
    );
  }
}
