import 'dart:io';
import 'dart:isolate';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/events/event_listener.dart';
import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/providers/provider_manager.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_listener.dart';
import 'package:mineral/src/infrastructure/internals/wss/sharding_config.dart';
import 'package:mineral/src/infrastructure/kernel/kernel.dart';

final class ClientBuilder {
  late final LoggerContract _logger;
  final EnvContract _env = Environment();

  CacheProviderContract? _cache;
  final List<EnvSchema> _schemas = [];
  final List<ProviderContract Function(Client)> _providers = [];

  SendPort? _devPort;
  bool _hasDefinedDevPort = false;

  final WatcherConfig _watcherConfig = WatcherConfig();

  ClientBuilder() {
    _logger = Logger(_env);
  }

  ClientBuilder setToken(String token) {
    _env.list[AppEnv.token.key] = token;
    return this;
  }

  ClientBuilder setIntent(int intent) {
    _env.list[AppEnv.intent.key] = intent.toString();
    return this;
  }

  ClientBuilder setHttpVersion(int version) {
    _env.list[AppEnv.httpVersion.key] = version.toString();
    return this;
  }

  ClientBuilder setWssVersion(int version) {
    _env.list[AppEnv.wssVersion.key] = version.toString();
    return this;
  }

  ClientBuilder setCache(CacheProviderContract Function(EnvContract) cache) {
    _cache = cache(_env);
    return this;
  }

  ClientBuilder setLogger(LoggerContract Function(EnvContract) logger) {
    _logger = logger(_env);
    return this;
  }

  ClientBuilder setHmrDevPort(SendPort? devPort) {
    _devPort = devPort;
    _hasDefinedDevPort = true;
    return this;
  }

  ClientBuilder validateEnvironment(List<EnvSchema> schema) {
    _schemas.addAll(schema);
    return this;
  }

  ClientBuilder addWatchedFile(File file) {
    _watcherConfig.watchedFiles.add(file);
    return this;
  }

  ClientBuilder addWatchedDirectory(Directory folder) {
    _watcherConfig.watchedFolders.add(folder);
    return this;
  }

  ClientBuilder registerProvider<T extends ProviderContract>(
      T Function(Client) provider) {
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

  Client build() {
    ioc
      ..bind<LoggerContract>(() => _logger)
      ..bind<EnvContract>(() => _env);

    _validateEnvironment();
    _createCache();

    final token = _env.get<String>(AppEnv.token);
    final httpVersion = int.parse(_env.get(AppEnv.httpVersion));
    final shardVersion = int.parse(_env.get(AppEnv.wssVersion));
    final intent = int.parse(_env.get(AppEnv.intent));

    final http = HttpClient(
        config: HttpClientConfigImpl(
            baseUrl: 'https://discord.com/api/v$httpVersion',
            headers: {
          Header.userAgent('Mineral'),
          Header.contentType('application/json'),
        }));

    final shardConfig =
        ShardingConfig(token: token, intent: intent, version: shardVersion);

    final packetListener = PacketListener();
    final eventListener = EventListener();
    final providerManager = ProviderManager();
    final globalStateManager = ioc.make(GlobalStateManager.new);

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
    );

    ioc
      ..bind<MarshallerContract>(() => Marshaller(_logger, _cache!))
      ..bind<DataStoreContract>(() => DataStore(http))
      ..bind<CommandInteractionManagerContract>(CommandInteractionManager.new);

    packetListener
      ..kernel = kernel
      ..init();

    final client = Client(kernel);

    for (final provider in _providers) {
      providerManager.register(provider(client));
    }

    return client;
  }
}
