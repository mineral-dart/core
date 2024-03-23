import 'package:mineral/application/container/ioc_container.dart';
import 'package:mineral/application/http/http_client.dart';
import 'package:mineral/domains/data_store/parts/channel_part.dart';
import 'package:mineral/domains/data_store/parts/member_part.dart';
import 'package:mineral/domains/data_store/parts/server_part.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';

abstract class DataStoreContract {
  HttpClient get client;
  MarshallerContract get marshaller;

  ChannelPart get channel;

  ServerPart get server;

  MemberPart get member;
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

  DataStore(this.client, this.marshaller) {
    channel = ChannelPart(this);
    server = ServerPart(this);
    member = MemberPart(this);
  }

  factory DataStore.singleton() => ioc.resolve('data_store');
}
