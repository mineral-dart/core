import 'package:mineral/framework.dart';
import 'package:mineral/src/api/invites/invite.dart';

class InviteCreateEvent extends Event {
  final Invite _invite;

  InviteCreateEvent(this._invite);

  Invite get invite => _invite;
}