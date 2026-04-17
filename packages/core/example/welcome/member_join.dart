import 'package:mineral/api.dart';
import 'package:mineral/events.dart';

final class MemberJoin extends ServerMemberAddEvent {
  @override
  Future<void> handle(Member member, Server server) async {
    final systemChannel = await server.channels.resolveSystemChannel();
    if (systemChannel == null) {
      return;
    }

    final displayName = member.nickname ?? member.globalName ?? member.username;

    final message = MessageBuilder.text(
      '👋 Welcome to **${server.name}**, $displayName!',
    )
      ..addButton(Button.primary(
        'welcome:${member.id.value}',
        label: 'Say hello',
        emoji: PartialEmoji.fromUnicode('🎉'),
      ));

    await systemChannel.send(message);
  }
}
