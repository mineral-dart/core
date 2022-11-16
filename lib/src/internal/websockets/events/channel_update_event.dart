import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

class ChannelUpdateEvent extends Event {
  final GuildChannel? _before;
  final GuildChannel _after;

  ChannelUpdateEvent(this._before, this._after);

  GuildChannel? get before => _before;
  GuildChannel get after => _after;
}
