import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/menus/mentionable_menu_interaction.dart';
import 'package:mineral/src/exceptions/bad_context_exception.dart';

class MentionableMenuCreateEvent extends Event {
  final MentionableMenuInteraction _interaction;

  MentionableMenuCreateEvent(this._interaction);

  MentionableMenuInteraction get interaction => _interaction;

  GuildMember get member {
    if (_interaction.guild == null) {
      throw BadContextException('You cannot have a GuildMember in this context (no guild)');
    }

    return _interaction.member!;
  }
}
