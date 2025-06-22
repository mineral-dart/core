import 'package:mineral/src/domains/services/http.dart';

final class Request<T> implements RequestContract {
  @override
  String? method;

  @override
  dynamic body;

  @override
  Set<Header> headers;

  @override
  Uri url;

  @override
  Map<String, String> queryParameters;

  Request(this.method, this.url, this.headers, this.body, this.queryParameters);

  static Request json(
      {required String endpoint,
      String? method,
      Set<Header>? headers,
      dynamic body}) {
    return Request<Map<String, dynamic>>(
      method,
      Uri.parse(endpoint),
      headers ?? {},
      body,
      {},
    );
  }

  @override
  Request copyWith({
    String? method,
    Uri? url,
    Set<Header>? headers,
    Object? body,
    Map<String, String>? queryParameters,
  }) {
    return Request(
      method ?? this.method,
      url ?? this.url,
      {...this.headers, ...(headers ?? {})},
      body ?? this.body,
      {...this.queryParameters, ...(queryParameters ?? {})},
    );
  }
}
