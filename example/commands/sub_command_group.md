```dart
import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

@Command(name: 'command', description: 'Command with subcommands', scope: 'GUILD', everyone: true)
@CommandGroup(name: 'group', description: 'Group of subcommands')
class SimpleCommand extends MineralCommand {
  @Subcommand(group: 'group', name: 'first', description: 'First subcommand description')
  Future<void> first (CommandInteraction interaction) async {
    await interaction.reply(
      content: 'Hello World !',
      private: true
    );
  }

  @Subcommand(group: 'group', name: 'second', description: 'Second subcommand description')
  Future<void> second (CommandInteraction interaction) async {
    await interaction.reply(
      content: 'Hello World !',
      private: true
    );
  }
}
```
