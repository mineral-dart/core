```dart
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

@Command(name: 'command', description: 'Command with subcommands', scope: 'GUILD', everyone: true)
class SimpleCommand extends MineralCommand {
  @Subcommand(name: 'first', description: 'First subcommand description')
  Future<void> first (CommandInteraction interaction) async {
    await interaction.reply(
      content: 'Hello World !',
      private: true
    );
  }

  @Subcommand(name: 'second', description: 'Second subcommand description')
  Future<void> second (CommandInteraction interaction) async {
    await interaction.reply(
        content: 'Hello World !',
        private: true
    );
  }
}
```
