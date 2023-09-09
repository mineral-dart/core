/// Header bucket used to store headers
final class HeaderBucket {
  /// Headers of [HttpClient]
  final Map<String, String> _headers = {};

  /// Get headers
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.all;
  /// ```
  Map<String, String> get all => _headers;

  /// Add a header
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.add('Content-Type', 'application/json');
  /// ```
  HeaderBucket add(String key, String value) {
    _headers[key] = value;
    return this;
  }

  /// Add all headers from a map
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.addAll({
  ///  'Content-Type': 'application/json',
  ///  'Accept': 'text/html',
  /// });
  /// ```
  HeaderBucket addAll(Map<String, String> headers) {
    _headers.addAll(headers);
    return this;
  }

  /// Clear all headers
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.clear();
  /// ```
  void clear() {
    _headers.clear();
  }

  /// Check if a header exists
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.containsKey('Content-Type');
  /// ```
  bool containsKey(String key) {
    return _headers.containsKey(key);
  }

  /// Check if a header exists then remove it
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.remove('Content-Type');
  /// ```
  void remove(String key) {
    _headers.remove(key);
  }

  /// Get a header bucket size
  int get length => _headers.length;

  /// Set Content-Type header
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.setContentType('application/json');
  /// ```
  void setContentType(String contentType) {
    _headers['Content-Type'] = contentType;
  }

  /// Set Accept header
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.setAccept('text/html');
  /// ```
  void setAccept(String accept) {
    _headers['Accept'] = accept;
  }

  /// Set Authorization header
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.setAuthorization('1234');
  /// ```
  void setAuthorization(String authorization) {
    _headers['Authorization'] = authorization;
  }

  /// Set User-Agent header
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// client.headers.setUserAgent('Mineral');
  /// ```
  void setUserAgent(String userAgent) {
    _headers['User-Agent'] = userAgent;
  }

  /// Check if a hasContentType header exists on bucket
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// print(client.headers.hasContentType);
  /// ```
  bool get hasContentType => _headers.containsKey('Content-Type');

  /// Check if a hasAccept header exists on bucket
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// print(client.headers.hasAccept);
  /// ```
  bool get hasAccept => _headers.containsKey('Accept');

  /// Check if a hasAuthorization header exists on bucket
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// print(client.headers.hasAuthorization);
  /// ```
  bool get hasAuthorization => _headers.containsKey('Authorization');

  /// Get a contentType value
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// print(client.headers.contentType);
  /// ```
  String? get contentType => _headers['Content-Type'];

  /// Get a accept value
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// print(client.headers.accept);
  /// ```
  String? get accept => _headers['Accept'];

  /// Get a authorization value
  /// ```dart
  /// final HttpClient client = HttpClient(baseUrl: '/');
  /// print(client.headers.authorization);
  /// ```
  String? get authorization => _headers['Authorization'];
}