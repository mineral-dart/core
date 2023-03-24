import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/exceptions/bad_context_exception.dart';

class DynamicMenuCreateEvent extends Event {
  final DynamicMenuInteraction _interaction;

  DynamicMenuCreateEvent(this._interaction);

  DynamicMenuInteraction get interaction => _interaction;

  GuildMember get member {
    if (_interaction.guild == null) {
      throw BadContextException('You cannot have a GuildMember in this context (no guild)');
    }

    return _interaction.member!;
  }
}
