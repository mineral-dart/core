import 'package:mineral/infrastructure/internals/datastore/parts/channel_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/interaction_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/member_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/role_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/server_message_part.dart';
import 'package:mineral/infrastructure/internals/datastore/parts/server_part.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/services/http/http_client.dart';

abstract class DataStoreContract {
  HttpClient get client;

  ChannelPart get channel;

  ServerPart get server;

  MemberPart get member;

  RolePart get role;

  ServerMessagePart get serverMessage;

  InteractionPart get interaction;
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
  late final RolePart role;

  @override
  late final ServerMessagePart serverMessage;

  @override
  late final InteractionPart interaction;

  DataStore(this.client);

  void init() {
    channel = ChannelPart(kernel);
    server = ServerPart(kernel);
    member = MemberPart(kernel);
    role = RolePart(kernel);
    interaction = InteractionPart(kernel);
    serverMessage = ServerMessagePart(kernel);
    serverMessage = ServerMessagePart(kernel);
  }
}
