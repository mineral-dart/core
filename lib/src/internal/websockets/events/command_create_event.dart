import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class CommandCreateEvent extends Event {
  final CommandInteraction _interaction;
  final dynamic _payload;

  CommandCreateEvent(this._interaction, this._payload);

  CommandInteraction get interaction => _interaction;
  GuildMember get sender => _interaction.member!;

  T getInteraction<T extends CommandInteraction>(CommandScope scope) {
    return scope.isGuild
        ? GuildCommandInteraction.fromPayload(_payload) as T
        : GlobalCommandInteraction.fromPayload(_payload) as T;
  }
}
