import 'dart:io';
import 'dart:isolate';

import 'package:mineral/domains/environment/app_env.dart';
import 'package:mineral/domains/environment/env_schema.dart';
import 'package:mineral/domains/environment/environment.dart';
import 'package:mineral/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';
import 'package:mineral/infrastructure/kernel/mineral_client.dart';
import 'package:mineral/infrastructure/internals/cache/cache_provider_contract.dart';
import 'package:mineral/domains/data/data_listener.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/wss/sharding_config.dart';
import 'package:mineral/infrastructure/services/http/header.dart';
import 'package:mineral/infrastructure/services/http/http_client.dart';
import 'package:mineral/infrastructure/services/http/http_client_config.dart';
import 'package:mineral/infrastructure/services/logger/logger.dart';

final class Client {
  late final LoggerContract _logger;
  final EnvContract _env = Environment();

  CacheProviderContract? _cache;
  final List<EnvSchema> _schemas = [];

  SendPort? _devPort;
  bool _hasDefinedDevPort = false;

  final WatcherConfig _watcherConfig = WatcherConfig();

  Client() {
    _logger = Logger(_env.get(AppEnv.logLevel));
  }

  Client setToken(String token) {
    _env.list[AppEnv.token.key] = token;
    return this;
  }

  Client setIntent(int intent) {
    _env.list[AppEnv.intent.key] = intent.toString();
    return this;
  }

  Client setHttpVersion(int version) {
    _env.list[AppEnv.httpVersion.key] = version.toString();
    return this;
  }

  Client setWssVersion(int version) {
    _env.list[AppEnv.wssVersion.key] = version.toString();
    return this;
  }

  Client setCache(CacheProviderContract Function(EnvContract) cache) {
    _cache = cache(_env);
    return this;
  }

  Client setHmr(bool hmr) {
    _env.list[AppEnv.hmr.key] = hmr.toString();
    return this;
  }

  Client setHmrDevPort(SendPort? devPort) {
    _devPort = devPort;
    _hasDefinedDevPort = true;
    return this;
  }

  Client validateEnvironment(List<EnvSchema> schema) {
    _schemas.addAll(schema);
    return this;
  }

  Client addWatchedFile(File file) {
    _watcherConfig.watchedFiles.add(file);
    return this;
  }

  Client addWatchedDirectory(Directory folder) {
    _watcherConfig.watchedFolders.add(folder);
    return this;
  }

  void _validateEnvironment() {
    _env
      ..validate(AppEnv.values)
      ..validate(_schemas);
  }

  void _createCache() {
    if (_cache == null) {
      throw Exception('Cache provider not set');
    }

    _cache!
      ..logger = _logger
      ..init();
  }

  MineralClientContract build() {
    ioc
      ..bind('logger', () => _logger)
      ..bind('environment', () => _env);

    _validateEnvironment();
    _createCache();

    final token = _env.get<String>(AppEnv.token);
    final httpVersion = _env.get<int>(AppEnv.httpVersion);
    final shardVersion = _env.get<int>(AppEnv.wssVersion);
    final intent = _env.get<int>(AppEnv.intent);
    final hmr = _env.get<bool>(AppEnv.hmr);

    if (hmr && !_hasDefinedDevPort) {
      throw Exception('HMR is enabled but no dev port defined');
    }

    final http = HttpClient(
        config: HttpClientConfigImpl(baseUrl: 'https://discord.com/api/v$httpVersion', headers: {
      Header.userAgent('Mineral'),
      Header.contentType('infrastructure/json'),
    }));

    final shardConfig = ShardingConfig(token: token, intent: intent, version: shardVersion);

    final MarshallerContract marshaller = Marshaller(_logger, _cache!);
    final DataStoreContract dataStore = DataStore(http, marshaller);

    final DataListenerContract dataListener = DataListener(_logger, marshaller);

    final kernel = Kernel(_devPort,
        watcherConfig: _watcherConfig,
        logger: _logger,
        environment: _env,
        httpClient: http,
        config: shardConfig,
        dataListener: dataListener,
        dataStore: dataStore,
    );

    return MineralClient(kernel);
  }
}
