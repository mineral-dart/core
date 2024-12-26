import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';

abstract class DataStoreContract {
  HttpClient get client;

  ChannelPartContract get channel;

  ServerPartContract get server;

  MemberPartContract get member;

  UserPartContract get user;

  RolePartContract get role;

  MessagePartContract get message;

  InteractionPartContract get interaction;

  StickerPartContract get sticker;

  ServerMessagePartContract get serverMessage;

  EmojiPartContract get emoji;
}
