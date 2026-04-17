import 'package:mineral/api.dart';

final class FeedbackCommand implements CommandDeclaration {
  Future<void> handle(ServerCommandContext ctx, CommandOptions options) async {
    final message = MessageBuilder.text(
      '💬 We value your feedback! Click below to share your thoughts.',
    )
      ..addButton(Button.primary('open_feedback', label: 'Give feedback'));

    await ctx.interaction.reply(builder: message);
  }

  @override
  CommandDeclarationBuilder build() {
    return CommandDeclarationBuilder()
      ..setName('feedback')
      ..setDescription('Share feedback with the server team')
      ..setHandle(handle);
  }
}
