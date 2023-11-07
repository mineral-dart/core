abstract interface class HttpMethod {
  String get name;
}

final class HttpMethodImpl implements HttpMethod {
  @override
  final String name;

  HttpMethodImpl(this.name);

  static HttpMethod get get => HttpMethodImpl('GET');
  static HttpMethod get post => HttpMethodImpl('POST');
  static HttpMethod get put => HttpMethodImpl('PUT');
  static HttpMethod get patch => HttpMethodImpl('PATCH');
  static HttpMethod get delete => HttpMethodImpl('DELETE');
}
