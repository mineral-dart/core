import 'dart:isolate';

import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/events/event_listener.dart';
import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/providers/provider_manager.dart';
import 'package:mineral/src/domains/services/wss/running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/environment/app_env.dart';
import 'package:mineral/src/infrastructure/internals/hmr/hot_module_reloading.dart';
import 'package:mineral/src/infrastructure/internals/hmr/watcher_config.dart';
import 'package:mineral/src/infrastructure/internals/wss/running_strategies/default_running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/wss/running_strategies/hmr_running_strategy.dart';

final class Kernel {
  final _watch = Stopwatch();

  final bool _hasDefinedDevPort;

  final SendPort? _devPort;

  final WatcherConfig watcherConfig;

  final WebsocketOrchestratorContract wss;

  final LoggerContract logger;

  final EnvContract environment;

  final HttpClientContract httpClient;

  final PacketListenerContract packetListener;

  final EventListenerContract eventListener;

  final ProviderManagerContract providerManager;

  HmrContract? hmr;

  late final RunningStrategy runningStrategy;

  final GlobalStateManagerContract globalState;

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
    httpClient.config.headers
        .add(Header.authorization('Bot ${wss.config.token}'));
  }

  Future<void> init() async {
    final isDevelopmentMode = environment.get(AppEnv.dartEnv) == 'development';
    final useHmr = isDevelopmentMode && _hasDefinedDevPort;

    if ((useHmr && Isolate.current.debugName != 'main') || !useHmr) {
      await providerManager.ready();
    }

    if (useHmr) {
      hmr = HotModuleReloading(_devPort, watcherConfig, this,
          () => wss.createShards(hmr, runningStrategy), wss.shards);
      runningStrategy = HmrRunningStrategy(_watch, hmr!);
    } else {
      runningStrategy = DefaultRunningStrategy(
          this, () => wss.createShards(hmr, runningStrategy));
    }

    await runningStrategy.init();
  }
}
