final class HeaderBucket {
  final Map<String, String> _headers = {};

  HeaderBucket add(String key, String value) {
    _headers[key] = value;
    return this;
  }

  HeaderBucket addAll(Map<String, String> headers) {
    _headers.addAll(headers);
    return this;
  }

  void clear() {
    _headers.clear();
  }

  bool containsKey(String key) {
    return _headers.containsKey(key);
  }

  void remove(String key) {
    _headers.remove(key);
  }

  int get length => _headers.length;

  void setContentType(String contentType) {
    _headers['Content-Type'] = contentType;
  }

  void setAccept(String accept) {
    _headers['Accept'] = accept;
  }

  void setAuthorization(String authorization) {
    _headers['Authorization'] = authorization;
  }

  bool get hasContentType => _headers.containsKey('Content-Type');

  bool get hasAccept => _headers.containsKey('Accept');

  bool get hasAuthorization => _headers.containsKey('Authorization');

  String? get contentType => _headers['Content-Type'];

  String? get accept => _headers['Accept'];

  String? get authorization => _headers['Authorization'];
}