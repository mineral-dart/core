import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral_test/mineral_test.dart';

/// Sends a welcome message to a configured channel when a member joins.
final class WelcomeListener extends OnMemberJoinListener {
  /// Channel id where the welcome message is sent.
  static const welcomeChannelId = 'welcome-channel-id';

  @override
  Future<void> handle(TestMember member, TestGuild server) async {
    final dataStore = ioc.resolve<DataStoreContract>();
    final builder = MessageBuilder.text(
      'hello ${member.user.username}, welcome to ${server.name}!',
    );
    await dataStore.message.send(server.id, welcomeChannelId, builder);
  }
}
