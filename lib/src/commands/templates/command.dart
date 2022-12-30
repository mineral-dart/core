final template = '''import 'package:mineral/framework.dart';
import 'package:mineral/core/api.dart';

class &ClassName extends MineralCommand {
  &ClassName () {
    register(CommandBuilder('&FilenameLowerCase', '&FilenameCapitalCase command description'));
  }
  
  Future<void> handle (CommandInteraction interaction) async {
    // Your code here
    await interaction.reply(content: 'Hello World ! 💪');
  }
}''';