import 'package:mineral/infrastructure/container/ioc_container.dart';
import 'package:mineral/infrastructure/http/http_client.dart';
import 'package:mineral/infrastructure/data_store/parts/channel_part.dart';
import 'package:mineral/infrastructure/data_store/parts/member_part.dart';
import 'package:mineral/infrastructure/data_store/parts/role_part.dart';
import 'package:mineral/infrastructure/data_store/parts/server_part.dart';
import 'package:mineral/infrastructure/marshaller/marshaller.dart';

abstract class DataStoreContract {
  HttpClient get client;
  MarshallerContract get marshaller;

  ChannelPart get channel;

  ServerPart get server;

  MemberPart get member;

  RolePart get role;
}

final class DataStore implements DataStoreContract {
  @override
  final HttpClient client;

  @override
  final MarshallerContract marshaller;

  @override
  late final ChannelPart channel;

  @override
  late final ServerPart server;

  @override
  late final MemberPart member;

  @override
  late final RolePart role;

  DataStore(this.client, this.marshaller) {
    channel = ChannelPart(this);
    server = ServerPart(this);
    member = MemberPart(this);
    role = RolePart(this);
  }

  factory DataStore.singleton() => ioc.resolve('data_store');
}
