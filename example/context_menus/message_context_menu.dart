import 'package:mineral/api.dart';
import 'package:mineral/core.dart';

@ContextMenu(name: 'message', type: ContextMenuType.message, scope: 'GUILD')
class MessageContext extends MineralContextMenu {
  Future<void> handle (ContextMessageInteraction interaction) async {
    await interaction.reply(content: interaction.message.content, private: true);
  }
}
