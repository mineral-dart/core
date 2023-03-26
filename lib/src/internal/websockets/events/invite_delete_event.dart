import 'package:mineral/framework.dart';
import 'package:mineral/src/api/invites/invite.dart';

class InviteDeleteEvent extends Event {
  final Invite? _invite;

  InviteDeleteEvent(this._invite);

  Invite? get invite =>_invite;
}