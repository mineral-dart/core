import 'dart:io';

import 'package:mineral/services.dart';
import 'package:mineral/src/infrastructure/services/http/header.dart' as infra;
import 'package:test/test.dart';

// ── Fakes ─────────────────────────────────────────────────────────────────────

final class _FakeResponse<T> implements Response<T> {
  @override
  final int statusCode;
  @override
  final Set<infra.Header> headers = {};
  @override
  final String bodyString = '';
  @override
  final T body;
  @override
  final Uri uri = Uri.parse('https://discord.com/api/v10/test');
  @override
  final String? reasonPhrase = null;
  @override
  final String method = 'GET';

  _FakeResponse(this.statusCode, this.body);
}

/// A configurable fake inner client. Each call to any HTTP method pops the
/// next entry from [_outcomes]; entries can be either a status code (int) or
/// an exception to throw.
final class _FakeInnerClient implements HttpClientContract {
  final List<Object> _outcomes;
  int callCount = 0;

  _FakeInnerClient(List<Object> outcomes) : _outcomes = List.of(outcomes);

  @override
  HttpClientStatus get status => HttpClientStatusImpl();
  @override
  HttpInterceptor get interceptor => HttpInterceptorImpl();
  @override
  HttpClientConfig get config => throw UnimplementedError();

  Future<Response<T>> _next<T>() async {
    callCount++;
    final outcome = _outcomes.removeAt(0);
    if (outcome is Exception) throw outcome;
    if (outcome is Error) throw outcome;
    return _FakeResponse<T>(outcome as int, null as T);
  }

  @override
  Future<Response<T>> get<T>(RequestContract request) => _next<T>();
  @override
  Future<Response<T>> post<T>(RequestContract request) => _next<T>();
  @override
  Future<Response<T>> put<T>(RequestContract request) => _next<T>();
  @override
  Future<Response<T>> patch<T>(RequestContract request) => _next<T>();
  @override
  Future<Response<T>> delete<T>(RequestContract request) => _next<T>();
  @override
  Future<Response<T>> send<T>(RequestContract request) => _next<T>();
}

Request get _req => Request.json(endpoint: '/test');

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('ResilientHttpClient', () {
    group('success on first attempt', () {
      test('returns response immediately for 200', () async {
        final inner = _FakeInnerClient([200]);
        final client = ResilientHttpClient(inner,
            maxRetries: 3, initialBackoff: Duration.zero);

        final response = await client.get(_req);

        expect(response.statusCode, 200);
        expect(inner.callCount, 1);
      });

      test('returns response immediately for 201', () async {
        final inner = _FakeInnerClient([201]);
        final client = ResilientHttpClient(inner,
            maxRetries: 3, initialBackoff: Duration.zero);

        final response = await client.post(_req);

        expect(response.statusCode, 201);
        expect(inner.callCount, 1);
      });
    });

    group('retries on transient server errors', () {
      for (final code in [500, 502, 503, 504]) {
        test('retries on $code and succeeds on next attempt', () async {
          final inner = _FakeInnerClient([code, 200]);
          final client = ResilientHttpClient(inner,
              maxRetries: 3, initialBackoff: Duration.zero);

          final response = await client.get(_req);

          expect(response.statusCode, 200);
          expect(inner.callCount, 2);
        });
      }

      test('exhausts all retries and returns last error response', () async {
        final inner = _FakeInnerClient([503, 503, 503, 503]); // 1 + 3 retries
        final client = ResilientHttpClient(inner,
            maxRetries: 3, initialBackoff: Duration.zero);

        final response = await client.get(_req);

        expect(response.statusCode, 503);
        expect(inner.callCount, 4);
      });

      test('stops after maxRetries even if errors continue', () async {
        final inner = _FakeInnerClient([502, 502, 200]); // succeeds on 3rd
        final client = ResilientHttpClient(inner,
            maxRetries: 2, initialBackoff: Duration.zero);

        final response = await client.get(_req);

        expect(response.statusCode, 200);
        expect(inner.callCount, 3);
      });
    });

    group('retries on SocketException', () {
      test('retries after SocketException and succeeds', () async {
        final inner = _FakeInnerClient([
          SocketException('connection refused'),
          200,
        ]);
        final client = ResilientHttpClient(inner,
            maxRetries: 3, initialBackoff: Duration.zero);

        final response = await client.get(_req);

        expect(response.statusCode, 200);
        expect(inner.callCount, 2);
      });

      test('rethrows SocketException after exhausting retries', () async {
        final inner = _FakeInnerClient([
          SocketException('unreachable'),
          SocketException('unreachable'),
        ]);
        final client = ResilientHttpClient(inner,
            maxRetries: 1, initialBackoff: Duration.zero);

        await expectLater(client.get(_req), throwsA(isA<SocketException>()));
        expect(inner.callCount, 2);
      });
    });

    group('does not retry non-transient errors', () {
      for (final code in [400, 401, 403, 404, 429]) {
        test('returns $code without retrying', () async {
          final inner = _FakeInnerClient([code]);
          final client = ResilientHttpClient(inner,
              maxRetries: 3, initialBackoff: Duration.zero);

          final response = await client.get(_req);

          expect(response.statusCode, code);
          expect(inner.callCount, 1);
        });
      }
    });

    group('delegates to inner client', () {
      test('delegates post()', () async {
        final inner = _FakeInnerClient([201]);
        final client = ResilientHttpClient(inner, initialBackoff: Duration.zero);

        await client.post(_req);
        expect(inner.callCount, 1);
      });

      test('delegates put()', () async {
        final inner = _FakeInnerClient([200]);
        final client = ResilientHttpClient(inner, initialBackoff: Duration.zero);

        await client.put(_req);
        expect(inner.callCount, 1);
      });

      test('delegates patch()', () async {
        final inner = _FakeInnerClient([200]);
        final client = ResilientHttpClient(inner, initialBackoff: Duration.zero);

        await client.patch(_req);
        expect(inner.callCount, 1);
      });

      test('delegates delete()', () async {
        final inner = _FakeInnerClient([200]);
        final client = ResilientHttpClient(inner, initialBackoff: Duration.zero);

        await client.delete(_req);
        expect(inner.callCount, 1);
      });

      test('exposes inner status', () {
        final inner = _FakeInnerClient([]);
        final client = ResilientHttpClient(inner);
        expect(client.status, isA<HttpClientStatus>());
      });

      test('exposes inner interceptor', () {
        final inner = _FakeInnerClient([]);
        final client = ResilientHttpClient(inner);
        expect(client.interceptor, isA<HttpInterceptor>());
      });
    });
  });
}
