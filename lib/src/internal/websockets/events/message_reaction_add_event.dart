import 'package:mineral/core/api.dart';
import 'package:mineral/framework.dart';

import '../../../../core/builders.dart';

class MessageReactionAddEvent extends Event {
  final Guild? _guild;
  final TextBasedChannel? _channel;
  final Message _message;
  final User _user;
  final GuildMember? _member;
  final EmojiBuilder _emoji;

  MessageReactionAddEvent(
    this._guild,
    this._channel,
    this._message,
    this._user,
    this._member,
    this._emoji,);


  Guild? get guild => _guild;
  TextBasedChannel? get channel => _channel;
  Message get message => _message;
  User get user => _user;
  GuildMember? get member => _member;
  EmojiBuilder get emoji => _emoji;
}
