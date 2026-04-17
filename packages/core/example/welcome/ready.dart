import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/events.dart';

final class Ready extends ReadyEvent with Logger {
  @override
  Future<void> handle(Bot bot) async {
    logger.info('${bot.username} is ready!');

    bot.setPresence(
      activities: [BotActivity.playing('with Mineral')],
      status: StatusType.online,
    );
  }
}
