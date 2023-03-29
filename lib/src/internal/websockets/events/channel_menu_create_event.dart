import 'package:mineral/framework.dart';
import 'package:mineral/src/api/interactions/menus/channel_menu_interaction.dart';

class ChannelMenuCreateEvent extends Event {
  final ChannelMenuInteraction _interaction;

  ChannelMenuCreateEvent(this._interaction);

  ChannelMenuInteraction get interaction => _interaction;
}
