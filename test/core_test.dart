import 'package:mineral/api.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/internal/event_emitter.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('can get Http from ioc', () {
    String discordEndpoint = 'https://discord.com/api';
    ioc.bind(namespace: ioc.services.http, service: Http(baseUrl: discordEndpoint));

    assert(ioc.singleton(ioc.services.http) is Http);
  });

  test('can emit with event emitter', () async {
    EventEmitter emitter = EventEmitter<Object?>();
    String key = 'foo';
    emitter.on(key, (params) {
      assert(params['bar'] == 'bar');
    });

    emitter.emit(key, { 'bar': 'bar' });
  });

  test('can create websocket connection', () async {
    String discordEndpoint = 'https://discord.com/api';

    Http http = Http(baseUrl: discordEndpoint);
    ShardManager manager = ShardManager(http, 'Nzg1ODgxOTk1NDc2ODYwOTc5.Gihx50.TKgmVB5cBsw-QV_W3kzAJdRP_Hk9CKZXUxbxnk', [Intent.all]);
    await manager.start(shardsCount: 1);
  });
}
