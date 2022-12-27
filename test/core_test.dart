import 'package:mineral/core.dart';
import 'package:mineral/core/api.dart';
import 'package:mineral/src/internal/managers/environment_manager.dart';
import 'package:mineral/src/internal/services/event_emitter_service.dart';
import 'package:mineral/src/internal/websockets/sharding/shard_manager.dart';
import 'package:mineral_ioc/ioc.dart';
import 'package:test/test.dart';

void main() {
  test('can get HttpService from ioc', () {
    String discordEndpoint = 'https://discord.com/api';
    ioc.bind((_) => HttpService(baseUrl: discordEndpoint));

    expect(ioc.use<HttpService>().baseUrl, equals(discordEndpoint));
  });

  test('can emit with event emitter', () async {
    EventEmitterService emitter = EventEmitterService<Object?>();
    String key = 'foo';
    emitter.on(key, (params) {
      assert(params['bar'] == 'bar');
    });

    emitter.emit(key, { 'bar': 'bar' });
  });

  test('can create websocket connection', () async {
    String discordEndpoint = 'https://discord.com/api';
    HttpService http = HttpService(baseUrl: discordEndpoint);

    EnvironmentManager manager = EnvironmentManager();
    manager.load();

    ShardManager shardManager = ShardManager(http, manager.environment.get("APP_TOKEN")!, [Intent.all]);
    await shardManager.start(shardsCount: 1);
  });
}
