import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/infrastructure/internals/datastore/request_bucket.dart';

abstract class DataStoreContract {
  RequestBucket get requestBucket;

  HttpClient get client;

  ChannelPartContract get channel;

  ServerPartContract get server;

  MemberPartContract get member;

  UserPartContract get user;

  RolePartContract get role;

  MessagePartContract get message;

  InteractionPartContract get interaction;

  StickerPartContract get sticker;

  EmojiPartContract get emoji;
}
