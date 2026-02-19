import 'package:mineral/api.dart';

void main(_, dynamic port) async {
  final client = ClientBuilder()
      .setHmrDevPort(port)
      .setIntent(Intent.allNonPrivileged)
      .build();

  // Simple command - just 4 lines!
  client.commands.declare((cmd) => cmd
    ..setName('hello')
    ..setDescription('Say hello')
    ..setHandle(
      (ServerCommandContext ctx, options) {
        final message = MessageBuilder.text('👋 Hello from Mineral!');

        final mineralLinkButton = Button.link(
          'https://mineral-dart.dev/',
          emoji: PartialEmoji.fromUnicode('📘'),
          label: 'Check our documentation',
        );
        message.addButton(mineralLinkButton);

        return ctx.interaction.reply(
          builder: message,
        );
      },
    ));

  await client.init();
}
