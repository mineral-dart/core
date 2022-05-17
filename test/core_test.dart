import 'package:mineral/core.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('can get Http from ioc', () {
    String namespace = 'Mineral/Core/Http';
    String discordEndpoint = 'https://discord.com/api';
    ioc.bind(namespace: namespace, service: Http(baseUrl: discordEndpoint));

    assert(ioc.singleton(namespace) is Http);
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
    WebsocketManager manager = WebsocketManager(http);
    await manager.connect(token: 'Nzg1ODgxOTk1NDc2ODYwOTc5.Gihx50.TKgmVB5cBsw-QV_W3kzAJdRP_Hk9CKZXUxbxnk');
  });
}
