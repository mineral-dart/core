import 'dart:async';

import 'package:mineral/api/common/bot.dart';
import 'package:mineral/api/server/guild.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';

typedef GuildCreateEventHandler = FutureOr<void> Function(Bot bot);

abstract class GuildCreateEvent implements ListenableEvent {
  @override
  String get event => 'GuildCreateEvent';

  FutureOr<void> handle(Guild guild);
}
