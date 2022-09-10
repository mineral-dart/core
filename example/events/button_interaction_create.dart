import 'package:mineral/api.dart';
import 'package:mineral/console.dart';
import 'package:mineral/core.dart';

@Event(Events.buttonCreate, customId: 'customId') // 👈 You can filter events by customId component
class ButtonCreate extends MineralEvent {
  Future<void> handle (ButtonInteraction interaction) async {
    Console.info(message: "Button ${interaction.customId} was clicked");

    await interaction.reply(
      content: 'Button ${interaction.customId} was clicked',
      private: true,
    );
  }
}
