import 'dart:io';
import 'dart:isolate';

import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/events/event_listener.dart';
import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/providers/provider.dart';
import 'package:mineral/src/domains/providers/provider_manager.dart';
import 'package:mineral/src/infrastructure/internals/cache/cache_provider_contract.dart';
import 'package:mineral/src/infrastructure/internals/container/ioc_container.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/environment/app_env.dart';
import 'package:mineral/src/infrastructure/internals/environment/env_schema.dart';
import 'package:mineral/src/infrastructure/internals/environment/environment.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/src/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_listener.dart';
import 'package:mineral/src/infrastructure/internals/wss/sharding_config.dart';
import 'package:mineral/src/infrastructure/kernel/kernel.dart';
import 'package:mineral/src/infrastructure/kernel/mineral_client.dart';
import 'package:mineral/src/infrastructure/services/http/header.dart';
import 'package:mineral/src/infrastructure/services/http/http_client.dart';
import 'package:mineral/src/infrastructure/services/http/http_client_config.dart';
import 'package:mineral/src/infrastructure/services/logger/logger.dart';

final class Client {
  late final LoggerContract _logger;
  final EnvContract _env = Environment();

  CacheProviderContract? _cache;
  final List<EnvSchema> _schemas = [];
  final List<ProviderContract Function(MineralClientContract)> _providers = [];

  SendPort? _devPort;
  bool _hasDefinedDevPort = false;

  final WatcherConfig _watcherConfig = WatcherConfig();

  Client() {
    _logger = Logger(_env);
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

  Client setLogger(LoggerContract Function(EnvContract) logger) {
    _logger = logger(_env);
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

  Client registerProvider<T extends ProviderContract>(T Function(MineralClientContract) provider) {
    _providers.add(provider);
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
      ..bind(LoggerContract, () => _logger)
      ..bind(EnvContract, () => _env);

    _validateEnvironment();
    _createCache();

    final token = _env.get<String>(AppEnv.token);
    final httpVersion = int.parse(_env.get(AppEnv.httpVersion));
    final shardVersion = int.parse(_env.get(AppEnv.wssVersion));
    final intent = int.parse(_env.get(AppEnv.intent));

    final http = HttpClient(
        config: HttpClientConfigImpl(baseUrl: 'https://discord.com/api/v$httpVersion', headers: {
      Header.userAgent('Mineral'),
      Header.contentType('application/json'),
    }));

    final shardConfig = ShardingConfig(token: token, intent: intent, version: shardVersion);

    final marshaller = Marshaller(_logger, _cache!);
    final datastore = DataStore(http);
    final commandInteractionManager = CommandInteractionManager(marshaller);

    ioc
      ..bind(MarshallerContract, () => marshaller)
      ..bind(DataStoreContract, () => datastore)
      ..bind(CommandInteractionManagerContract, () => commandInteractionManager);

    final packetListener = PacketListener();
    final eventListener = EventListener();
    final providerManager = ProviderManager();
    final globalStateManager = GlobalStateManager();
    ioc.bind(GlobalStateService, () => globalStateManager);

    final kernel = Kernel(
      _hasDefinedDevPort,
      _devPort,
      watcherConfig: _watcherConfig,
      logger: _logger,
      environment: _env,
      httpClient: http,
      config: shardConfig,
      packetListener: packetListener,
      providerManager: providerManager,
      eventListener: eventListener,
      globalState: globalStateManager,
      marshaller: marshaller,
      dataStore: datastore,
      commands: commandInteractionManager,
    );


    datastore.kernel = kernel;
    packetListener.kernel = kernel;

    datastore.init();
    packetListener.init();

    final client = MineralClient(kernel);

    for (final provider in _providers) {
      providerManager.register(provider(client));
    }

    return client;
  }
}
