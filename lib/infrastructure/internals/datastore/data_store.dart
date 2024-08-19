import 'package:mineral/infrastructure/internals/datastore/parts/channel_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/interaction_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/member_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/message_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/role_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/server_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/sticker_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/user_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client.dart';

abstract class DataStoreContract {
  HttpClient get client;

  ChannelPart get channel;

  ServerPart get server;

  MemberPart get member;

  UserPart get user;

  RolePart get role;

  MessagePart get message;

  InteractionPart get interaction;

  StickerPart get sticker;
}

final class DataStore implements DataStoreContract {
  @override
  final HttpClient client;

  late final KernelContract kernel;

  @override
  late final ChannelPart channel;

  @override
  late final ServerPart server;

  @override
  late final MemberPart member;

  @override
  late final UserPart user;

  @override
  late final RolePart role;

  @override
  late final MessagePart message;

  @override
  late final InteractionPart interaction;

  @override
  late final StickerPart sticker;

  DataStore(this.client);

  void init() {
    channel = ChannelPart(kernel);
    server = ServerPart(kernel);
    member = MemberPart(kernel);
    user = UserPart(kernel);
    role = RolePart(kernel);
    message = MessagePart(kernel);
    interaction = InteractionPart(kernel);
    sticker = StickerPart(kernel);
  }
}
