import 'dart:async';

import 'package:mineral/api.dart';
import 'package:mineral/container.dart';
import 'package:mineral/contracts.dart';
import 'package:mineral/src/domains/services/wss/constants/shard_disconnect_error.dart';
import 'package:mineral/src/domains/services/wss/running_strategy.dart';
import 'package:mineral/src/infrastructure/internals/wss/dispatchers/shard_network_error.dart';
import 'package:mineral/src/infrastructure/internals/wss/shard.dart';
import 'package:mineral/src/infrastructure/internals/wss/websocket_isolate_message_transfert.dart';
import 'package:mineral/src/infrastructure/services/wss/interceptor.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_client.dart';
import 'package:mineral/src/infrastructure/services/wss/websocket_message.dart';
import 'package:test/test.dart';

// ── Fakes ──────────────────────────────────────────────────────────────────

final class _FakeLogger implements LoggerContract {
  final List<String> warnings = [];
  final List<String> errors = [];
  final List<Object> traces = [];

  @override
  void trace(Object message) {
    traces.add(message);
  }

  @override
  void fatal(Exception message) {}
  @override
  void error(String message) => errors.add(message);
  @override
  void warn(String message) => warnings.add(message);
  @override
  void info(String message) {}
}

final class _FakeShardingConfig implements ShardingConfigContract {
  final int _maxReconnect;

  _FakeShardingConfig({int maxReconnect = 0}) : _maxReconnect = maxReconnect;

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
  int? get shardCount => 1;
  @override
  int get maxReconnectAttempts => _maxReconnect;
  @override
  Duration get maxReconnectDelay => Duration.zero;
}

final class _FakeWebsocketOrchestrator extends WebsocketOrchestratorContract {
  final _FakeShardingConfig _config;

  _FakeWebsocketOrchestrator({int maxReconnect = 0})
      : _config = _FakeShardingConfig(maxReconnect: maxReconnect);

  @override
  final List<({String uid, List<String> targetKeys, Completer completer})>
      requestQueue = [];
  @override
  ShardingConfigContract get config => _config;
  @override
  Map<int, ShardContract> get shards => {};
  @override
  void send(WebsocketIsolateMessageTransfert message) {}
  @override
  void setBotPresence(
      List<BotActivity>? activity, StatusType? status, bool? afk) {}
  @override
  Future<Map<String, dynamic>> getWebsocketEndpoint() async => {};
  @override
  Future<void> createShards(RunningStrategy strategy) async {}
  @override
  Future<Presence> getMemberPresence(String serverId, String id) {
    throw UnimplementedError();
  }
}

final class _FakeRunningStrategy implements RunningStrategy {
  @override
  FutureOr<void> init(RunningStrategyFactory createShards) async {}
  @override
  FutureOr<void> dispatch(WebsocketMessage message) {}
}

final class _FakeWebsocketClient implements WebsocketClient {
  bool disconnected = false;
  final List<String> sentMessages = [];

  @override
  String get name => 'fake';
  @override
  String get url => 'wss://fake';
  @override
  Stream? get stream => null;
  @override
  Interceptor get interceptor => _FakeInterceptor();
  @override
  Future<void> connect() async {}
  @override
  void disconnect({int? code, String? reason}) {
    disconnected = true;
  }

  @override
  Future<void> send(String message) async {
    sentMessages.add(message);
  }

  @override
  Future<void> listen(void Function(WebsocketMessage) callback) async {}
}

final class _FakeInterceptor implements Interceptor {
  @override
  final List<MessageInterceptor> message = [];
  @override
  final List<RequestInterceptor> request = [];
}

// ── Helpers ────────────────────────────────────────────────────────────────

/// Creates a shard with maxReconnectAttempts=0 so resume/reconnect
/// throw FatalGatewayException synchronously within the async method
/// before reaching shard.init().
Shard _createShard({int maxReconnect = 0}) {
  return Shard(
    shardName: 'test-shard-0',
    url: 'wss://fake',
    wss: _FakeWebsocketOrchestrator(maxReconnect: maxReconnect),
    strategy: _FakeRunningStrategy(),
  );
}

/// Runs [fn] while silencing uncaught async errors (from fire-and-forget
/// futures inside dispatch). Returns any synchronous error thrown by [fn].
Object? _dispatchSilently(void Function() fn) {
  Object? caught;
  runZonedGuarded(() {
    try {
      fn();
    } on Object catch (e) {
      caught = e;
    }
  }, (_, __) {
    // Silently absorb uncaught async errors from resume()/reconnect()
  });
  return caught;
}

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('ShardNetworkError', () {
    late _FakeLogger logger;
    late void Function() restoreIoc;

    setUp(() {
      logger = _FakeLogger();
      final scope = IocContainer()..bind<LoggerContract>(() => logger);
      restoreIoc = scopedIoc(scope);
    });

    tearDown(() {
      restoreIoc();
    });

    test('does nothing when payload is null', () {
      final shard = _createShard();
      shard.client = _FakeWebsocketClient();
      final networkError = ShardNetworkError(shard);

      networkError.dispatch(null);

      expect(logger.warnings, isEmpty);
      expect(logger.errors, isEmpty);
      expect((shard.client as _FakeWebsocketClient).disconnected, isFalse);
    });

    group('resume codes', () {
      test('logs warning for code 4000 (unknownError)', () {
        final shard = _createShard();
        shard.client = _FakeWebsocketClient();
        final networkError = ShardNetworkError(shard);

        _dispatchSilently(() => networkError.dispatch(4000));

        expect(logger.warnings, contains(contains('code 4000')));
      });

      test('logs warning for code 4009 (sessionTimeout)', () {
        final shard = _createShard();
        shard.client = _FakeWebsocketClient();
        final networkError = ShardNetworkError(shard);

        _dispatchSilently(() => networkError.dispatch(4009));

        expect(logger.warnings, contains(contains('code 4009')));
      });

      test('disconnects client when resuming', () {
        final shard = _createShard();
        final fakeClient = _FakeWebsocketClient();
        shard.client = fakeClient;
        final networkError = ShardNetworkError(shard);

        _dispatchSilently(() => networkError.dispatch(4000));

        expect(fakeClient.disconnected, isTrue);
      });
    });

    group('reconnect codes', () {
      test('logs warning for code 1000 (normal)', () {
        final shard = _createShard();
        shard.client = _FakeWebsocketClient();
        final networkError = ShardNetworkError(shard);

        _dispatchSilently(() => networkError.dispatch(1000));

        expect(logger.warnings, contains(contains('code 1000')));
      });

      test('logs warning for code 1001 (goingAway)', () {
        final shard = _createShard();
        shard.client = _FakeWebsocketClient();
        final networkError = ShardNetworkError(shard);

        _dispatchSilently(() => networkError.dispatch(1001));

        expect(logger.warnings, contains(contains('code 1001')));
      });

      test('disconnects client when reconnecting', () {
        final shard = _createShard();
        final fakeClient = _FakeWebsocketClient();
        shard.client = fakeClient;
        final networkError = ShardNetworkError(shard);

        _dispatchSilently(() => networkError.dispatch(1000));

        expect(fakeClient.disconnected, isTrue);
      });
    });

    group('fatal codes', () {
      test('logs fatal error and disconnects for code 4004', () {
        final shard = _createShard();
        final fakeClient = _FakeWebsocketClient();
        shard.client = fakeClient;
        final networkError = ShardNetworkError(shard);

        final error = _dispatchSilently(() => networkError.dispatch(4004));

        expect(error, isNotNull);
        expect(logger.errors, contains(contains('Fatal gateway error')));
        expect(logger.errors.first, contains('4004'));
        expect(fakeClient.disconnected, isTrue);
      });

      test('logs fatal error and disconnects for code 4014', () {
        final shard = _createShard();
        final fakeClient = _FakeWebsocketClient();
        shard.client = fakeClient;
        final networkError = ShardNetworkError(shard);

        final error = _dispatchSilently(() => networkError.dispatch(4014));

        expect(error, isNotNull);
        expect(logger.errors, contains(contains('Fatal gateway error')));
        expect(fakeClient.disconnected, isTrue);
      });

      test('logs fatal error and disconnects for code 4010 (invalidShard)', () {
        final shard = _createShard();
        final fakeClient = _FakeWebsocketClient();
        shard.client = fakeClient;
        final networkError = ShardNetworkError(shard);

        final error = _dispatchSilently(() => networkError.dispatch(4010));

        expect(error, isNotNull);
        expect(logger.errors, contains(contains('Fatal gateway error')));
        expect(fakeClient.disconnected, isTrue);
      });
    });

    group('unknown codes', () {
      test('logs warning about unknown code', () {
        final shard = _createShard();
        shard.client = _FakeWebsocketClient();
        final networkError = ShardNetworkError(shard);

        _dispatchSilently(() => networkError.dispatch(9999));

        expect(logger.warnings, contains(contains('unknown code: 9999')));
      });

      test('disconnects client for unknown code', () {
        final shard = _createShard();
        final fakeClient = _FakeWebsocketClient();
        shard.client = fakeClient;
        final networkError = ShardNetworkError(shard);

        _dispatchSilently(() => networkError.dispatch(1234));

        expect(fakeClient.disconnected, isTrue);
      });
    });
  });

  group('ShardDisconnectError enum', () {
    test('resume codes include all expected Discord resume codes', () {
      final resumeCodes = ShardDisconnectError.values
          .where((e) => e.action == DisconnectAction.resume)
          .map((e) => e.code)
          .toList();

      expect(resumeCodes,
          containsAll([4000, 4001, 4002, 4003, 4005, 4007, 4008, 4009]));
    });

    test('reconnect codes include all expected Discord reconnect codes', () {
      final reconnectCodes = ShardDisconnectError.values
          .where((e) => e.action == DisconnectAction.reconnect)
          .map((e) => e.code)
          .toList();

      expect(reconnectCodes, containsAll([1000, 1001, 1002, 1003, 1005]));
    });

    test('fatal codes include all expected Discord fatal codes', () {
      final fatalCodes = ShardDisconnectError.values
          .where((e) => e.action == DisconnectAction.fatal)
          .map((e) => e.code)
          .toList();

      expect(fatalCodes, containsAll([4004, 4010, 4011, 4012, 4013, 4014]));
    });

    test('every enum value has a non-empty message', () {
      for (final error in ShardDisconnectError.values) {
        expect(error.message, isNotEmpty,
            reason: '${error.name} should have a non-empty message');
      }
    });

    test('every enum value has a valid action', () {
      for (final error in ShardDisconnectError.values) {
        expect(
          error.action,
          isIn([
            DisconnectAction.resume,
            DisconnectAction.reconnect,
            DisconnectAction.fatal,
          ]),
        );
      }
    });
  });
}
