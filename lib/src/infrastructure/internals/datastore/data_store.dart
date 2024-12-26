import 'package:mineral/src/domains/commons/kernel.dart';
import 'package:mineral/src/domains/contracts/datastore/datastore.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/channel_part.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/empji_part.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/interaction_part.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/member_part.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/message_part.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/role_part.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/server_message_part.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/server_part.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/sticker_part.dart';
import 'package:mineral/src/infrastructure/internals/datastore/parts/user_part.dart';
import 'package:mineral/src/infrastructure/services/http/http_client.dart';

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

  @override
  late final ServerMessagePart serverMessage;

  @override
  late final EmojiPart emoji;

  DataStore(this.client)
      : channel = ChannelPart(),
        server = ServerPart(),
        member = MemberPart(),
        user = UserPart(),
        role = RolePart(),
        message = MessagePart(),
        interaction = InteractionPart(),
        sticker = StickerPart(),
        serverMessage = ServerMessagePart(),
        emoji = EmojiPart();
}
