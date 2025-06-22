import 'dart:io';
import 'dart:isolate';

import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/commons/kernel.dart';
import 'package:mineral/src/domains/commons/utils/helper.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event_listener.dart';
import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/providers/provider_manager.dart';
import 'package:mineral/src/infrastructure/internals/datastore/data_store.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_listener.dart';
import 'package:mineral/src/infrastructure/internals/scaffolding/scaffold.dart';
import 'package:mineral/src/infrastructure/internals/wss/sharding_config.dart';
import 'package:mineral/src/infrastructure/internals/wss/websocket_orchestrator.dart';

final class ClientBuilder {
  late final LoggerContract _logger;
  final EnvContract _env = Environment();

  CacheProviderContract? _cache;
  final List<EnvSchema> _schemas = [];
  final List<ConstructableWithArgs<ProviderContract, Client>> _providers = [];

  ScaffoldContract _scaffold = DefaultScaffold();
  SendPort? _devPort;
  bool _hasDefinedDevPort = false;
  EncodingStrategy _wsEncodingStrategy = JsonEncoderStrategy();

  final WatcherConfig _watcherConfig = WatcherConfig();

  ClientBuilder() {
    _logger = Logger(_env);
  }

  ClientBuilder overrideScaffold(Constructable<ScaffoldContract> scaffold) {
    _scaffold = scaffold();
    return this;
  }

  ClientBuilder setToken(String token) {
    _env.list[AppEnv.token.key] = token;
    return this;
  }

  ClientBuilder setIntent(int intent) {
    _env.list[AppEnv.intent.key] = intent.toString();
    return this;
  }

  ClientBuilder setDiscordRestHttpVersion(int version) {
    _env.list[AppEnv.discordRestHttpVersion.key] = version.toString();
    return this;
  }

  ClientBuilder setDiscordWssVersion(int version) {
    _env.list[AppEnv.discordWssVersion.key] = version.toString();
    return this;
  }

  ClientBuilder setEncoder(Constructable<EncodingStrategy> encoding) {
    _wsEncodingStrategy = encoding();
    return this;
  }

  ClientBuilder setCache(
      ConstructableWithArgs<CacheProviderContract, EnvContract> cache) {
    _cache = cache(_env);
    ioc.bind<CacheProviderContract>(() => _cache!);
    return this;
  }

  ClientBuilder setLogger(
      ConstructableWithArgs<LoggerContract, EnvContract> logger) {
    _logger = logger(_env);
    return this;
  }

  ClientBuilder setHmrDevPort(SendPort? devPort) {
    _devPort = devPort;
    _hasDefinedDevPort = true;

    ioc.bind<SendPort?>(() => _devPort);

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
    if (_cache case final CacheProviderContract cache) {
      cache
        ..logger = _logger
        ..init();
    }
  }

  Client build() {
    _watcherConfig.watchedFiles.add(_scaffold.entrypoint);

    ioc
      ..bind<ScaffoldContract>(() => _scaffold)
      ..bind<LoggerContract>(() => _logger)
      ..bind<EnvContract>(() => _env);

    _validateEnvironment();
    _createCache();

    final token = _env.get<String>(AppEnv.token);
    final httpVersion = int.parse(_env.get(AppEnv.discordRestHttpVersion));
    final shardVersion = int.parse(_env.get(AppEnv.discordWssVersion));
    final intent = int.parse(_env.get(AppEnv.intent));

    final http = HttpClient(
        config: HttpClientConfigImpl(
            uri: Uri.parse('https://discord.com/api/v$httpVersion'),
            headers: {
          Header.userAgent('Mineral'),
          Header.contentType('application/json'),
        }));

    final shardConfig = ShardingConfig(
        token: token,
        intent: intent,
        version: shardVersion,
        encoding: _wsEncodingStrategy);

    final packetListener = PacketListener();
    final eventListener = EventListener();
    final providerManager = ProviderManager();
    final globalStateManager = ioc.make(GlobalStateManager.new);
    final interactiveComponent = ioc.make<InteractiveComponentManagerContract>(
        InteractiveComponentManager.new);
    final wssOrchestrator = ioc.make<WebsocketOrchestratorContract>(
        () => WebsocketOrchestrator(shardConfig));

    final kernel = Kernel(
      _hasDefinedDevPort,
      _devPort,
      watcherConfig: _watcherConfig,
      logger: _logger,
      environment: _env,
      httpClient: http,
      packetListener: packetListener,
      providerManager: providerManager,
      eventListener: eventListener,
      globalState: globalStateManager,
      interactiveComponent: interactiveComponent,
      wss: wssOrchestrator,
    );

    final datastore = DataStore(http);

    ioc
      ..bind<HttpClientContract>(() => http)
      ..bind<Kernel>(() => kernel)
      ..bind<MarshallerContract>(Marshaller.new)
      ..bind<DataStoreContract>(() => datastore)
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
