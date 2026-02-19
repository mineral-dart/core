import 'dart:isolate';

import 'package:glob/glob.dart';
import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/commands/command_interaction_manager.dart';
import 'package:mineral/src/domains/common/kernel.dart';
import 'package:mineral/src/domains/common/utils/helper.dart';
import 'package:mineral/src/domains/container/ioc_container.dart';
import 'package:mineral/src/domains/events/event_listener.dart';
import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/providers/provider_manager.dart';
import 'package:mineral/src/infrastructure/internals/datastore/datastore.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_listener.dart';
import 'package:mineral/src/infrastructure/internals/wss/sharding_config.dart';
import 'package:mineral/src/infrastructure/internals/wss/websocket_orchestrator.dart';

/// Builder for configuring and creating a Discord bot client.
///
/// The [ClientBuilder] provides a fluent API for configuring all aspects of
/// your bot before connecting to Discord. It handles dependency injection,
/// environment validation, caching, logging, providers, and WebSocket configuration.
///
/// ## Environment File Support
///
/// The builder automatically reads configuration from a `.env` file in your
/// project root. This allows you to configure your bot without hardcoding values:
///
/// **.env**:
/// ```env
/// DISCORD_TOKEN=your_bot_token_here
/// DISCORD_INTENT=32767
/// DISCORD_REST_HTTP_VERSION=10
/// DISCORD_WSS_VERSION=10
/// DISCORD_WSS_ENCODING=json
/// LOG_LEVEL=info
/// DART_ENV=production
/// ```
///
/// Values set via builder methods take precedence over `.env` file values,
/// and `.env` values take precedence over defaults.
///
/// ## Basic Usage
///
/// ```dart
/// void main() {
///   // Token and intent can be loaded from .env automatically
///   final client = ClientBuilder().build();
///   client.init();
/// }
/// ```
///
/// ```dart
/// void main() {
///   // Or configure explicitly (overrides .env values)
///   final client = ClientBuilder()
///     ..setToken('YOUR_BOT_TOKEN')
///     ..setIntent(Intent.guilds | Intent.guildMessages)
///     ..build();
///
///   client.init();
/// }
/// ```
///
/// ## Complete Configuration
///
/// ```dart
/// void main() {
///   final client = ClientBuilder()
///     // Authentication & Gateway
///     ..setToken(env.get('DISCORD_TOKEN'))
///     ..setIntent(Intent.all)
///     ..setDiscordRestHttpVersion(10)
///     ..setDiscordWssVersion(10)
///     ..setEncoder(WebsocketEncoder.etf)
///
///     // Logging & Caching
///     ..setLogger(Logger.new)
///     ..setCache(RedisProvider.new)
///
///     // Environment Validation
///     ..validateEnvironment([
///       EnvSchema('DATABASE_URL', required: true),
///       EnvSchema('API_KEY', required: true),
///     ])
///
///     // Providers
///     ..registerProvider((client) => DatabaseProvider())
///     ..registerProvider((client) => WebhookProvider())
///
///     // Hot Module Replacement (Development)
///     ..setHmrDevPort(devPort)
///     ..watch([Glob('lib/**/*.dart')])
///
///     ..build();
///
///   client.init();
/// }
/// ```
///
/// ## Configuration Options
///
/// ### Authentication & Gateway
/// - [setToken]: Discord bot token
/// - [setIntent]: Gateway intents for event subscriptions
/// - [setDiscordRestHttpVersion]: Discord REST API version (default: 10)
/// - [setDiscordWssVersion]: Discord Gateway version (default: 10)
/// - [setEncoder]: WebSocket encoding (JSON or ETF)
///
/// ### Logging & Caching
/// - [setLogger]: Custom logger implementation
/// - [setCache]: Cache provider (memory, Redis, etc.)
///
/// ### Environment & Validation
/// - [validateEnvironment]: Define required environment variables
///
/// ### Providers
/// - [registerProvider]: Register custom service providers
///
/// ### Development Features
/// - [setHmrDevPort]: Enable hot module replacement
/// - [watch]: Watch files for changes
///
/// ## Environment Variables (.env file)
///
/// The builder automatically loads these variables from your `.env` file:
///
/// **Required:**
/// - `DISCORD_TOKEN`: Bot token (can be set via [setToken])
/// - `DISCORD_INTENT`: Gateway intents as integer (can be set via [setIntent])
///
/// **Optional with defaults:**
/// - `DISCORD_REST_HTTP_VERSION`: REST API version (default: 10)
/// - `DISCORD_WSS_VERSION`: Gateway version (default: 10)
/// - `DISCORD_WSS_ENCODING`: WebSocket encoding: "json" or "etf" (default: json)
/// - `LOG_LEVEL`: Logging level: "debug", "info", "warning", "error" (default: info)
/// - `DART_ENV`: Environment mode: "development" or "production" (default: development)
///
/// **Priority order** (highest to lowest):
/// 1. Values set via builder methods ([setToken], [setIntent], etc.)
/// 2. Values in `.env` file
/// 3. Default values
///
/// ## Best Practices
///
/// - **Environment variables**: Use environment variables for sensitive data
/// - **Intents**: Only request intents you need to reduce memory usage
/// - **Caching**: Use Redis in production for multi-instance deployments
/// - **Logging**: Configure appropriate log level for environment
/// - **Providers**: Register providers before building
/// - **Validation**: Validate critical environment variables early
///
/// ## Example with Multiple Configurations
///
/// ```dart
/// void main() {
///   final isDev = env.get(AppEnv.dartEnv) == DartEnv.development;
///
///   final builder = ClientBuilder()
///     ..setIntent(
///       Intent.guilds |
///       Intent.guildMessages |
///       Intent.guildMembers,
///     );
///
///   if (isDev) {
///     // Development-specific configuration
///     builder
///       ..setCache(MemoryProvider.new)
///       ..setHmrDevPort(devPort)
///       ..watch([Glob('lib/**/*.dart')]);
///   } else {
///     // Production-specific configuration
///     builder
///       ..setCache(RedisProvider.new)
///       ..setEncoder(WebsocketEncoder.etf)
///       ..validateEnvironment([
///         EnvSchema('REDIS_URL', required: true),
///         EnvSchema('DATABASE_URL', required: true),
///       ]);
///   }
///
///   final client = builder.build();
///   client.init();
/// }
/// ```
///
/// See also:
/// - [Client] for the bot client instance
/// - [Intent] for available gateway intents
/// - [WebsocketEncoder] for encoding strategies
final class ClientBuilder {
  late final LoggerContract _logger;
  CacheProviderContract? _cache;
  final List<EnvSchema> _schemas = [];
  final List<ConstructableWithArgs<ProviderContract, Client>> _providers = [];

  SendPort? _devPort;
  bool _hasDefinedDevPort = false;
  WebsocketEncoder _wssEncoder = WebsocketEncoder.json;

  String? _token;
  int? _intent;
  int? _discordRestHttpVersion;
  int? _discordWssVersion;
  final List<Glob> _watchedFiles = [];

  /// Builds and returns the configured [Client] instance.
  ///
  /// This method:
  /// 1. Validates the environment
  /// 2. Initializes the logger
  /// 3. Sets up the cache provider
  /// 4. Configures HTTP and WebSocket connections
  /// 5. Initializes all registered providers
  /// 6. Returns a ready-to-use client
  ///
  /// After calling [build], call [Client.init] to connect to Discord.
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setToken('YOUR_BOT_TOKEN')
  ///   ..setIntent(Intent.all)
  ///   ..build();
  ///
  /// await client.init();
  /// ```
  Client build() {
    _validateEnvironment();

    final logLevel = env.get(AppEnv.logLevel);
    final dartEnv = env.get<DartEnv>(AppEnv.dartEnv);

    _logger = ioc.make<LoggerContract>(() => Logger(logLevel, dartEnv.value));

    _createCache();

    final token = env.get<String>(AppEnv.token, defaultValue: _token);
    final intent = env.get<int>(AppEnv.intent, defaultValue: _intent);

    final httpVersion = env.get<int>(AppEnv.discordRestHttpVersion,
        defaultValue: _discordRestHttpVersion);

    final shardVersion = env.get<int>(AppEnv.discordWssVersion,
        defaultValue: _discordWssVersion);

    final wsEncodingStrategy =
        env.get(AppEnv.discordWssEncoding, defaultValue: _wssEncoder);

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
        encoding: wsEncodingStrategy.strategy());

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
      _watchedFiles,
      logger: _logger,
      httpClient: http,
      packetListener: packetListener,
      providerManager: providerManager,
      eventListener: eventListener,
      globalState: globalStateManager,
      interactiveComponent: interactiveComponent,
      wss: wssOrchestrator,
    );

    ioc
      ..bind<HttpClientContract>(() => http)
      ..bind<Kernel>(() => kernel)
      ..bind<MarshallerContract>(Marshaller.new)
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

  /// Registers a custom service provider.
  ///
  /// Providers are initialized before the bot connects to Discord and can
  /// inject services, handle lifecycle events, and extend bot functionality.
  ///
  /// Example:
  /// ```dart
  /// final class DatabaseProvider implements ProviderContract {
  ///   late final Database db;
  ///
  ///   @override
  ///   Future<void> init() async {
  ///     db = await Database.connect();
  ///   }
  /// }
  ///
  /// final client = ClientBuilder()
  ///   ..registerProvider((client) => DatabaseProvider())
  ///   ..build();
  /// ```
  ClientBuilder registerProvider<T extends ProviderContract>(
      T Function(Client) provider) {
    _providers.add(provider);
    return this;
  }

  /// Sets the cache provider for storing Discord entities.
  ///
  /// Cache providers store Discord objects (guilds, channels, users, etc.)
  /// to reduce API calls and improve performance.
  ///
  /// Available providers:
  /// - `MemoryProvider`: In-memory cache (default, good for development)
  /// - `RedisProvider`: Redis cache (recommended for production)
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setCache(RedisProvider.new)
  ///   ..build();
  /// ```
  ClientBuilder setCache(
      ConstructableWithArgs<CacheProviderContract, Env> cache) {
    _cache = ioc.make<CacheProviderContract>(() => cache(env));
    return this;
  }

  /// Sets the Discord REST API version to use.
  ///
  /// **Priority:** This method overrides the `DISCORD_REST_HTTP_VERSION` value
  /// from `.env` file.
  ///
  /// **Default:** Version 10
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setDiscordRestHttpVersion(10)
  ///   ..build();
  /// ```
  ClientBuilder setDiscordRestHttpVersion(int version) {
    _discordRestHttpVersion = version;
    return this;
  }

  /// Sets the Discord Gateway (WebSocket) version to use.
  ///
  /// **Priority:** This method overrides the `DISCORD_WSS_VERSION` value
  /// from `.env` file.
  ///
  /// **Default:** Version 10
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setDiscordWssVersion(10)
  ///   ..build();
  /// ```
  ClientBuilder setDiscordWssVersion(int version) {
    _discordWssVersion = version;
    return this;
  }

  /// Sets the WebSocket encoding strategy.
  ///
  /// Available encoders:
  /// - [WebsocketEncoder.json]: JSON encoding (default, easier debugging)
  /// - [WebsocketEncoder.etf]: ETF encoding (more efficient, recommended for production)
  ///
  /// **Priority:** This method overrides the `DISCORD_WSS_ENCODING` value
  /// from `.env` file (values: "json" or "etf").
  ///
  /// **Default:** JSON encoding
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setEncoder(WebsocketEncoder.etf)
  ///   ..build();
  /// ```
  ClientBuilder setEncoder(WebsocketEncoder encoding) {
    _wssEncoder = encoding;
    return this;
  }

  /// Enables hot module replacement (HMR) for development.
  ///
  /// When enabled, the bot can reload code changes without restarting.
  /// Used in conjunction with [watch] to monitor file changes.
  ///
  /// Only active in development mode.
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setHmrDevPort(devPort)
  ///   ..watch([Glob('lib/**/*.dart')])
  ///   ..build();
  /// ```
  ClientBuilder setHmrDevPort(SendPort? devPort) {
    _devPort = devPort;
    _hasDefinedDevPort = true;

    ioc.bind<SendPort?>(() => _devPort);

    return this;
  }

  /// Sets the gateway intents for event subscriptions.
  ///
  /// Intents control which events your bot receives from Discord. Use bitwise
  /// OR (`|`) to combine multiple intents.
  ///
  /// **Priority:** This method overrides the `DISCORD_INTENT` value from `.env` file.
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setIntent(Intent.guilds | Intent.guildMessages | Intent.guildMembers)
  ///   ..build();
  /// ```
  ///
  /// If not set, the intent will be read from the `DISCORD_INTENT` environment
  /// variable in your `.env` file (as an integer).
  ///
  /// See also:
  /// - [Intent] for available intent values
  ClientBuilder setIntent(int intent) {
    _intent = intent;
    return this;
  }

  /// Sets a custom logger implementation.
  ///
  /// The logger is used for all framework logging. The default [Logger]
  /// implementation respects the `LOG_LEVEL` environment variable.
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setLogger(Logger.new)
  ///   ..build();
  /// ```
  ClientBuilder setLogger(ConstructableWithArgs<LoggerContract, Env> logger) {
    _logger = logger(env);
    return this;
  }

  /// Sets the Discord bot token for authentication.
  ///
  /// The token is used to authenticate your bot with Discord's gateway and REST API.
  ///
  /// **Priority:** This method overrides the `DISCORD_TOKEN` value from `.env` file.
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setToken('YOUR_BOT_TOKEN')
  ///   ..build();
  /// ```
  ///
  /// If not set, the token will be read from the `DISCORD_TOKEN` environment
  /// variable in your `.env` file.
  ClientBuilder setToken(String token) {
    _token = token;
    return this;
  }

  /// Validates required environment variables at startup.
  ///
  /// Ensures that critical environment variables are defined before the
  /// bot starts, preventing runtime errors.
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..validateEnvironment([
  ///     EnvSchema('DATABASE_URL', required: true),
  ///     EnvSchema('API_KEY', required: true),
  ///     EnvSchema('PORT', required: false, defaultValue: '3000'),
  ///   ])
  ///   ..build();
  /// ```
  ClientBuilder validateEnvironment(List<EnvSchema> schema) {
    _schemas.addAll(schema);
    return this;
  }

  /// Watches files for changes to enable hot module replacement.
  ///
  /// Specify glob patterns for files to monitor. When files change,
  /// the bot will reload the affected modules without restarting.
  ///
  /// Only active in development mode when used with [setHmrDevPort].
  ///
  /// Example:
  /// ```dart
  /// final client = ClientBuilder()
  ///   ..setHmrDevPort(devPort)
  ///   ..watch([
  ///     Glob('lib/commands/**/*.dart'),
  ///     Glob('lib/events/**/*.dart'),
  ///   ])
  ///   ..build();
  /// ```
  ClientBuilder watch(List<Glob> globs) {
    _watchedFiles.addAll(globs);
    return this;
  }

  void _createCache() {
    final isDevelopmentMode = env.get(AppEnv.dartEnv) == DartEnv.development;
    final isMainIsolate = Isolate.current.debugName == 'main';

    if (isDevelopmentMode && isMainIsolate) {
      return;
    }

    if (_cache case final CacheProviderContract cache) {
      cache.init();
    }
  }

  void _validateEnvironment() {
    env.defineOf(AppEnv.new);
  }
}
