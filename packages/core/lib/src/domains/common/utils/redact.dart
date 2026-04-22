const _sensitiveKeys = {'token', 'password', 'secret', 'authorization'};

Map<String, dynamic> redactSensitiveFields(Map<String, dynamic> payload) {
  return payload.map((key, value) {
    if (_sensitiveKeys.contains(key)) {
      return MapEntry(key, '***');
    }
    if (value is Map<String, dynamic>) {
      return MapEntry(key, redactSensitiveFields(value));
    }
    if (value is List) {
      return MapEntry(key, _redactList(value));
    }
    return MapEntry(key, value);
  });
}

List<dynamic> _redactList(List<dynamic> list) {
  return list.map((item) {
    if (item is Map<String, dynamic>) return redactSensitiveFields(item);
    if (item is List) return _redactList(item);
    return item;
  }).toList();
}
