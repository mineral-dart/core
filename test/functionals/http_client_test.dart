import 'package:mineral/services/http/http_client.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main () {
  test('create http_client', () {
    HttpClient client = HttpClient(baseUrl: '/');
    expect(client, isA<HttpClient>());
  });

  test('can add headers', () {
    HttpClient client = HttpClient(baseUrl: '/');
    expect(client.headers.length, equals(0));

    client.headers.add('Content-Type', 'application/json');
    expect(client.headers.length, equals(1));
  });

  test('can set Content-Type', () {
    final contentType = 'application/json';

    HttpClient client = HttpClient(baseUrl: '/');
    expect(client.headers.hasContentType, equals(false));

    client.headers.setContentType(contentType);
    expect(client.headers.hasContentType, equals(true));
    expect(client.headers.contentType, equals(contentType));
  });

  test('can set Authorization', () {
    final authorization = '1234';

    HttpClient client = HttpClient(baseUrl: '/');
    expect(client.headers.hasAuthorization, equals(false));

    client.headers.setAuthorization(authorization);
    expect(client.headers.hasAuthorization, equals(true));
    expect(client.headers.authorization, equals(authorization));
  });

  test('can set Accept Mime', () {
    final accept = 'text/html';

    HttpClient client = HttpClient(baseUrl: '/');
    expect(client.headers.hasAccept, equals(false));

    client.headers.setAccept(accept);
    expect(client.headers.hasAccept, equals(true));
    expect(client.headers.accept, equals(accept));
  });
}