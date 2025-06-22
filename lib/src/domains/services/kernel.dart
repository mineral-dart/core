import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/contracts/wss/running_strategy.dart';
import 'package:mineral/src/domains/events/event_listener.dart';
import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/providers/provider_manager.dart';

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
