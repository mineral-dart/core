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
import 'package:mineral/src/infrastructure/internals/datastore/datastore.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_listener.dart';
import 'package:mineral/src/infrastructure/internals/scaffolding/scaffold.dart';
import 'package:mineral/src/infrastructure/internals/wss/sharding_config.dart';
import 'package:mineral/src/infrastructure/internals/wss/websocket_orchestrator.dart';

final class ClientBuilder {
  late final LoggerContract _logger;
  CacheProviderContract? _cache;
  final List<EnvSchema> _schemas = [];
  final List<ConstructableWithArgs<ProviderContract, Client>> _providers = [];

  ScaffoldContract _scaffold = DefaultScaffold();
  SendPort? _devPort;
  bool _hasDefinedDevPort = false;
  EncodingStrategy _wsEncodingStrategy = JsonEncoderStrategy();

  String? _token;
  int? _intent;
  int? _discordRestHttpVersion;
  int? _discordWssVersion;

  final WatcherConfig _watcherConfig = WatcherConfig();

  ClientBuilder overrideScaffold(Constructable<ScaffoldContract> scaffold) {
    _scaffold = scaffold();
    return this;
  }

  ClientBuilder setToken(String token) {
    _token = token;
    return this;
  }

  ClientBuilder setIntent(int intent) {
    _intent = intent;
    return this;
  }

  ClientBuilder setDiscordRestHttpVersion(int version) {
    _discordRestHttpVersion = version;
    return this;
  }

  ClientBuilder setDiscordWssVersion(int version) {
    _discordWssVersion = version;
    return this;
  }

  ClientBuilder setEncoder(Constructable<EncodingStrategy> encoding) {
    _wsEncodingStrategy = encoding();
    return this;
  }

  ClientBuilder setCache(
      ConstructableWithArgs<CacheProviderContract, Env> cache) {
    _cache = ioc.make<CacheProviderContract>(() => cache(env));
    return this;
  }

  ClientBuilder setLogger(ConstructableWithArgs<LoggerContract, Env> logger) {
    _logger = logger(env);
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
    env.defineOf(AppEnv.new);
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

    _validateEnvironment();

    final logLevel = env.get(AppEnv.logLevel);
    final dartEnv = env.get<DartEnv>(AppEnv.dartEnv);

    ioc.bind<ScaffoldContract>(() => _scaffold);
    _logger = ioc.make<LoggerContract>(() => Logger(logLevel, dartEnv.value));

    _createCache();

    final token = _token ?? env.get<String>(AppEnv.token);
    final httpVersion =
        _discordRestHttpVersion ?? env.get<int>(AppEnv.discordRestHttpVersion);
    final shardVersion =
        _discordWssVersion ?? env.get<int>(AppEnv.discordWssVersion);
    final intent = _intent ?? env.get<int>(AppEnv.intent);

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
