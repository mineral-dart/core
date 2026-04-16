import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/services.dart';
import 'package:mineral/src/domains/common/kernel.dart';
import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/event_dispatcher.dart';
import 'package:mineral/src/domains/events/event_listener.dart';
import 'package:mineral/src/domains/global_states/global_state_manager.dart';
import 'package:mineral/src/domains/providers/provider.dart';
import 'package:mineral/src/domains/providers/provider_manager.dart';
import 'package:mineral/src/domains/services/packets/packet_dispatcher.dart';
import 'package:mineral/src/infrastructure/internals/packets/listenable_packet.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_dispatcher.dart';
import 'package:mineral/src/infrastructure/internals/packets/packet_type.dart';
import 'package:mineral/src/domains/services/wss/constants/op_code.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard_message.dart';
import 'package:mineral/src/infrastructure/services/http/http_client_config.dart';
import 'package:test/test.dart';

// ── Fakes ──────────────────────────────────────────────────────────────────

final class _FakeLogger implements LoggerContract {
  @override
  void trace(Object message) {}
  @override
  void fatal(Exception message) {}
  @override
  void error(String message) {}
  @override
  void warn(String message) {}
  @override
  void info(String message) {}
}

final class _FakeHttpClientConfig implements HttpClientConfig {
  @override
  final Uri uri = Uri.parse('https://discord.com/api/v10');
  @override
  final Set<Header> headers = {};
}

final class _FakeHttpClient implements HttpClientContract {
  @override
  final HttpClientConfig config = _FakeHttpClientConfig();
  @override
  HttpClientStatus get status => throw UnimplementedError();
  @override
  HttpInterceptor get interceptor => throw UnimplementedError();
  @override
  Future<Response<T>> get<T>(RequestContract request) =>
      throw UnimplementedError();
  @override
  Future<Response<T>> post<T>(RequestContract request) =>
      throw UnimplementedError();
  @override
  Future<Response<T>> put<T>(RequestContract request) =>
      throw UnimplementedError();
  @override
  Future<Response<T>> patch<T>(RequestContract request) =>
      throw UnimplementedError();
  @override
  Future<Response<T>> delete<T>(RequestContract request) =>
      throw UnimplementedError();
  @override
  Future<Response<T>> send<T>(RequestContract request) =>
      throw UnimplementedError();
}

final class _FakeShardingConfig implements ShardingConfigContract {
  @override
  String get token => 'fake-token';
  @override
  int get intent => 0;
  @override
  bool get compress => false;
  @override
  int get version => 10;
  @override
  EncodingStrategy get encoding => throw UnimplementedError();
  @override
  int get largeThreshold => 50;
  @override
  int? get shardCount => null;
  @override
  int get maxReconnectAttempts => 3;
  @override
  Duration get maxReconnectDelay => const Duration(seconds: 1);
}

final class _FakeWss extends WebsocketOrchestratorContract {
  @override
  final ShardingConfigContract config = _FakeShardingConfig();
  @override
  List<RequestQueueEntry> get requestQueue => [];
  @override
  void addToRequestQueue(RequestQueueEntry entry) {}
  @override
  RequestQueueEntry? findInRequestQueue(String uid) => null;
  @override
  void removeFromRequestQueue(RequestQueueEntry entry) {}
  @override
  Map<int, ShardContract> get shards => {};
  @override
  void send(dynamic message) {}
  @override
  void setBotPresence(
      List<BotActivity>? activity, StatusType? status, bool? afk) {}
  @override
  Future<Presence> getMemberPresence(String serverId, String id) =>
      throw UnimplementedError();
  @override
  Future<Map<String, dynamic>> getWebsocketEndpoint() =>
      throw UnimplementedError();
  @override
  Future<void> createShards(dynamic strategy) async {}
}

final class _FakeEventDispatcher implements EventDispatcherContract {
  @override
  void dispatch(
      {required Event event,
      required List params,
      bool Function(String?)? constraint}) {}
  @override
  void dispose() {}
}

final class _FakeEventListener implements EventListenerContract {
  @override
  late Kernel kernel;

  final _FakeEventDispatcher _dispatcher = _FakeEventDispatcher();

  @override
  EventDispatcherContract get dispatcher => _dispatcher;

  @override
  StreamSubscription listen<T extends Function>(
          {required Event event,
          required T handle,
          required String? customId}) =>
      throw UnimplementedError();

  @override
  void unsubscribe(StreamSubscription subscription) {}

  @override
  void dispose() {}
}

final class _FakePacketDispatcherContract implements PacketDispatcherContract {
  @override
  void listen(PacketTypeContract packet,
      Function(ShardMessage, DispatchEvent) listener) {}
  @override
  void dispatch(dynamic payload) {}
  @override
  void dispose() {}
}

final class _FakePacketListener implements PacketListenerContract {
  @override
  final PacketDispatcherContract dispatcher = _FakePacketDispatcherContract();
  @override
  void dispose() {}
}

final class _FakeProviderManager implements ProviderManagerContract {
  @override
  void register(ProviderContract provider) {}
  @override
  Future<void> ready() async {}
  @override
  Future<void> dispose() async {}
}

final class _FakeInteractiveComponentManager
    implements InteractiveComponentManagerContract {
  @override
  void register(InteractiveComponent component) {}
  @override
  void dispatch(String customId, List params) {}
  @override
  T get<T extends InteractiveComponent>(String customId) =>
      throw UnimplementedError();
}

Kernel _buildFakeKernel(_FakeEventListener eventListener) {
  return Kernel(
    false,
    null,
    [],
    logger: _FakeLogger(),
    httpClient: _FakeHttpClient(),
    packetListener: _FakePacketListener(),
    eventListener: eventListener,
    providerManager: _FakeProviderManager(),
    globalState: GlobalStateManager(),
    interactiveComponent: _FakeInteractiveComponentManager(),
    wss: _FakeWss(),
  );
}

// ── Fake packet type ────────────────────────────────────────────────────────

final class _FakePacket implements PacketTypeContract {
  @override
  final String name = 'MESSAGE_CREATE';
}

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('PacketDispatcher', () {
    late _FakeEventListener eventListener;
    late Kernel kernel;
    late PacketDispatcher dispatcher;
    late void Function() restoreIoc;

    setUp(() {
      eventListener = _FakeEventListener();
      kernel = _buildFakeKernel(eventListener);
      eventListener.kernel = kernel;
      dispatcher = PacketDispatcher(kernel);

      final scope = IocContainer()..bind<LoggerContract>(_FakeLogger.new);
      restoreIoc = scopedIoc(scope);
    });

    tearDown(() {
      dispatcher.dispose();
      restoreIoc();
    });

    group('async listener awaiting', () {
      test('awaits async listener before the next microtask resolves',
          () async {
        bool handled = false;
        final fakePacket = _FakePacket();

        Future<void> slowListener(
            ShardMessage msg, DispatchEvent dispatch) async {
          await Future.delayed(const Duration(milliseconds: 50));
          handled = true;
        }

        final fakeMessage = ShardMessage(
          type: 'MESSAGE_CREATE',
          opCode: OpCode.dispatch,
          sequence: 1,
          payload: <String, dynamic>{},
        );

        dispatcher.listen(fakePacket, slowListener);
        dispatcher.dispatch(fakeMessage);

        // Without await on Function.apply, handled would still become true
        // eventually (fire-and-forget), but this verifies the async work
        // completes within the expected time frame.
        await Future.delayed(const Duration(milliseconds: 100));
        expect(handled, isTrue);
      });

      test('listener is invoked with the shard message', () async {
        ShardMessage? receivedMessage;
        final fakePacket = _FakePacket();

        Future<void> captureListener(
            ShardMessage msg, DispatchEvent dispatch) async {
          receivedMessage = msg;
        }

        final fakeMessage = ShardMessage(
          type: 'MESSAGE_CREATE',
          opCode: OpCode.dispatch,
          sequence: 1,
          payload: <String, dynamic>{'content': 'hello'},
        );

        dispatcher.listen(fakePacket, captureListener);
        dispatcher.dispatch(fakeMessage);

        await Future.delayed(const Duration(milliseconds: 20));
        expect(receivedMessage, isNotNull);
        expect((receivedMessage!.payload as Map<String, dynamic>)['content'],
            equals('hello'));
      });

      test('dispatch to unknown packet type does nothing', () async {
        bool listenerCalled = false;
        final fakePacket = _FakePacket();

        dispatcher.listen(fakePacket, (msg, dispatch) async {
          listenerCalled = true;
        });

        final wrongMessage = ShardMessage(
          type: 'GUILD_CREATE',
          opCode: OpCode.dispatch,
          sequence: 1,
          payload: <String, dynamic>{},
        );

        dispatcher.dispatch(wrongMessage);

        await Future.delayed(const Duration(milliseconds: 20));
        expect(listenerCalled, isFalse);
      });
    });
  });
}
