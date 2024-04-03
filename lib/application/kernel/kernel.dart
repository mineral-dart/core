import 'package:mineral/application/container/ioc_container.dart';
import 'package:mineral/application/environment/app_env.dart';
import 'package:mineral/application/environment/environment.dart';
import 'package:mineral/application/environment/env_schema.dart';
import 'package:mineral/application/http/header.dart';
import 'package:mineral/application/http/http_client.dart';
import 'package:mineral/application/http/http_client_config.dart';
import 'package:mineral/application/logger/logger.dart';
import 'package:mineral/domains/cache/contracts/cache_provider_contract.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/domains/data_store/data_store.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/shared/types/kernel_contract.dart';
import 'package:mineral/domains/wss/shard.dart';
import 'package:mineral/domains/wss/sharding_config.dart';

final class Kernel implements KernelContract {
  @override
  final Map<int, Shard> shards = {};

  @override
  final ShardingConfigContract config;

  @override
  final LoggerContract logger;

  @override
  final EnvContract environment;

  @override
  final HttpClientContract httpClient;

  @override
  final DataListenerContract dataListener;

  @override
  final DataStoreContract dataStore;

  Kernel(
      {required this.logger,
      required this.environment,
      required this.httpClient,
      required this.config,
      required this.dataListener,
      required this.dataStore}) {
    httpClient.config.headers.addAll([
      Header.authorization('Bot ${config.token}'),
    ]);

    ioc
      ..bind('logger', () => logger)
      ..bind('environment', () => environment)
      ..bind('data_store', () => dataStore);
  }

  Future<Map<String, dynamic>> getWebsocketEndpoint() async {
    final response = await httpClient.get('/gateway/bot');
    return switch (response.statusCode) {
      200 => response.body,
      401 => throw Exception('This token is invalid or revocated !'),
      _ => throw Exception(response.body['message']),
    };
  }

  @override
  Future<void> init() async {
    final {'url': String endpoint, 'shards': int shardCount} = await getWebsocketEndpoint();

    for (int i = 0; i < (config.shardCount ?? shardCount); i++) {
      final shard = Shard(shardName: 'shard #$i', url: '$endpoint/?v=${config.version}', kernel: this);
      shards.putIfAbsent(i, () => shard);

      await shard.init();
    }
  }

  factory Kernel.create(
      {required String token,
      required int intent,
      required List<EnvSchema> environment,
      required CacheProviderContract Function(EnvContract) cache,
      int httpVersion = 10,
      int shardVersion = 10}) {
    final env = Environment()..validate(environment);

    final logLevel = env.getRawOrFail<String>('LOG_LEVEL');
    final LoggerContract logger = Logger(logLevel);

    final cacheInstance = cache(env)
      ..logger = logger
      ..init();

    final http = HttpClient(
        config: HttpClientConfigImpl(baseUrl: 'https://discord.com/api/v$httpVersion', headers: {
      Header.userAgent('Mineral'),
      Header.contentType('application/json'),
    }));

    final shardConfig = ShardingConfig(token: token, intent: intent, version: shardVersion);

    final MarshallerContract marshaller = Marshaller(logger, cacheInstance);
    final DataStoreContract dataStore = DataStore(http, marshaller);
    final DataListenerContract dataListener = DataListener(logger, marshaller);

    return Kernel(
        logger: logger,
        environment: env,
        httpClient: http,
        config: shardConfig,
        dataListener: dataListener,
        dataStore: dataStore);
  }

  factory Kernel.fromEnvironment(
      {required CacheProviderContract Function(EnvContract) cache, List<EnvSchema>? environment}) {
    final env = Environment()..validate(AppEnv.values);
    if (environment != null) {
      env.validate(environment);
    }

    final logLevel = env.getRawOrFail<String>('LOG_LEVEL');
    final LoggerContract logger = Logger(logLevel);

    final cacheInstance = cache(env)
      ..logger = logger
      ..init();

    final token = env.getRawOrFail<String>('TOKEN');
    final httpVersion = env.getRawOrFail<int>('HTTP_VERSION');
    final shardVersion = env.getRawOrFail<int>('WSS_VERSION');
    final intent = env.getRawOrFail<int>('INTENT');

    final http = HttpClient(
        config: HttpClientConfigImpl(baseUrl: 'https://discord.com/api/v$httpVersion', headers: {
      Header.userAgent('Mineral'),
      Header.contentType('application/json'),
    }));

    final shardConfig = ShardingConfig(token: token, intent: intent, version: shardVersion);

    final MarshallerContract marshaller = Marshaller(logger, cacheInstance);
    final DataStoreContract dataStore = DataStore(http, marshaller);

    final DataListenerContract dataListener = DataListener(logger, marshaller);

    return Kernel(
        logger: logger,
        environment: env,
        httpClient: http,
        config: shardConfig,
        dataListener: dataListener,
        dataStore: dataStore);
  }
}
