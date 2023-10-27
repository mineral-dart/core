import 'package:mineral/api/server/contracts/guild_contracts.dart';
import 'package:mineral/internal/factories/events/contracts/event_contract.dart';

abstract interface class GuildUpdateEventContract implements EventContract {
  Future<void> handle (GuildContract before, GuildContract after);
}