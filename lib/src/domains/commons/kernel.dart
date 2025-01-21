import 'dart:isolate';

import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/contracts/wss/running_strategy.dart';
import 'package:mineral/src/domains/events/event_listener.dart';
import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/providers/provider_manager.dart';
import 'package:mineral/src/infrastructure/internals/environment/app_env.dart';
import 'package:mineral/src/infrastructure/internals/hmr/hot_module_reloading.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/src/infrastructure/internals/wss/running_strategies/default_running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/wss/running_strategies/hmr_running_strategy.dart';
import 'package:mineral/src/infrastructure/services/http/header.dart';
import 'package:mineral/src/infrastructure/services/http/http_client.dart';

abstract interface class KernelContract {
  WebsocketOrchestratorContract get wss;

  LoggerContract get logger;

  EnvContract get environment;

  HttpClientContract get httpClient;

  PacketListenerContract get packetListener;

  EventListenerContract get eventListener;

  ProviderManagerContract get providerManager;

  HmrContract? get hmr;

  RunningStrategy get runningStrategy;

  GlobalStateManagerContract get globalState;

  InteractiveComponentManagerContract get interactiveComponent;

  Future<void> init();
}

final class Kernel implements KernelContract {
  final _watch = Stopwatch();

  final bool _hasDefinedDevPort;

  final SendPort? _devPort;

  final WatcherConfig watcherConfig;

  @override
  final WebsocketOrchestratorContract wss;

  @override
  final LoggerContract logger;

  @override
  final EnvContract environment;

  @override
  final HttpClientContract httpClient;

  @override
  final PacketListenerContract packetListener;

  @override
  final EventListenerContract eventListener;

  @override
  final ProviderManagerContract providerManager;

  @override
  HmrContract? hmr;

  @override
  late final RunningStrategy runningStrategy;

  @override
  final GlobalStateManagerContract globalState;

  @override
  InteractiveComponentManagerContract interactiveComponent;

  Kernel(
    this._hasDefinedDevPort,
    this._devPort, {
    required this.logger,
    required this.environment,
    required this.httpClient,
    required this.packetListener,
    required this.eventListener,
    required this.providerManager,
    required this.globalState,
    required this.interactiveComponent,
    required this.watcherConfig,
    required this.wss,
  }) {
    _watch.start();
    httpClient.config.headers.addAll([
      Header.authorization('Bot ${wss.config.token}'),
    ]);
  }

  @override
  Future<void> init() async {
    final isDevelopmentMode = environment.get(AppEnv.dartEnv) == 'development';
    final useHmr = isDevelopmentMode && _hasDefinedDevPort;

    if ((useHmr && Isolate.current.debugName != 'main') || !useHmr) {
      await providerManager.ready();
    }

    if (useHmr) {
      hmr = HotModuleReloading(_devPort, watcherConfig, this, () => wss.createShards(hmr, runningStrategy), wss.shards);
      runningStrategy = HmrRunningStrategy(_watch, hmr!);
    } else {
      runningStrategy = DefaultRunningStrategy(this, () => wss.createShards(hmr, runningStrategy));
    }

    await runningStrategy.init();
  }
}
