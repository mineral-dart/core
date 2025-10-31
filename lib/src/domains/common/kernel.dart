import 'dart:isolate';

import 'package:glob/glob.dart';
import 'package:mineral/api.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/events/event_listener.dart';
import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/providers/provider_manager.dart';
import 'package:mineral/src/domains/services/wss/running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/wss/running_strategies/default_running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/wss/running_strategies/hmr_running_strategy.dart';

final class Kernel {
  final _watch = Stopwatch();

  final bool _hasDefinedDevPort;

  final SendPort? _devPort;

  final List<Glob> _watchedFiles;

  final WebsocketOrchestratorContract wss;

  final LoggerContract logger;

  final HttpClientContract httpClient;

  final PacketListenerContract packetListener;

  final EventListenerContract eventListener;

  final ProviderManagerContract providerManager;

  late final RunningStrategy runningStrategy;

  final GlobalStateManagerContract globalState;

  InteractiveComponentManagerContract interactiveComponent;

  Kernel(
    this._hasDefinedDevPort,
    this._devPort,
    this._watchedFiles, {
    required this.logger,
    required this.httpClient,
    required this.packetListener,
    required this.eventListener,
    required this.providerManager,
    required this.globalState,
    required this.interactiveComponent,
    required this.wss,
  }) {
    _watch.start();
    httpClient.config.headers.add(
      Header.authorization('Bot ${wss.config.token}'),
    );
  }

  Future<void> init() async {
    final isDevelopmentMode = env.get(AppEnv.dartEnv) == DartEnv.development;
    final useHmr = isDevelopmentMode && _hasDefinedDevPort;

    if ((useHmr && Isolate.current.debugName == DartEnv.development.value) ||
        !useHmr) {
      await providerManager.ready();
    }

    runningStrategy = useHmr
        ? HmrRunningStrategy(_devPort, packetListener.dispatcher, _watchedFiles)
        : DefaultRunningStrategy(packetListener.dispatcher);

    await runningStrategy.init(wss.createShards);
  }
}
