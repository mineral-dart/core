/// Default exact-match keys (compared case-insensitively).
const _defaultSensitiveKeys = <String>{
  'token',
  'password',
  'secret',
  'authorization',
  'api_key',
  'apikey',
  'access_token',
  'refresh_token',
  'session_token',
  'id_token',
  'bearer',
  'bearer_token',
  'client_secret',
  'webhook_url',
  'private_key',
  'signing_key',
};

/// Default regex patterns matched against the lowercased key.
final _defaultSensitivePatterns = <RegExp>[
  RegExp(r'_token$'),
  RegExp(r'_secret$'),
  RegExp(r'_key$'),
  RegExp(r'^x-signature'),
  RegExp(r'-signature$'),
];

final Set<String> _sensitiveKeys = {..._defaultSensitiveKeys};
final List<RegExp> _sensitivePatterns = [..._defaultSensitivePatterns];

/// Registers an extra exact-match key (case-insensitive) for redaction.
void addSensitiveKey(String key) {
  _sensitiveKeys.add(key.toLowerCase());
}

/// Registers an extra regex pattern matched against the lowercased key.
void addSensitivePattern(RegExp pattern) {
  _sensitivePatterns.add(pattern);
}

/// Restores the default exact-match keys and patterns. Intended for tests.
void resetSensitiveKeys() {
  _sensitiveKeys
    ..clear()
    ..addAll(_defaultSensitiveKeys);
  _sensitivePatterns
    ..clear()
    ..addAll(_defaultSensitivePatterns);
}

bool _isSensitive(String key) {
  final lower = key.toLowerCase();
  if (_sensitiveKeys.contains(lower)) {
    return true;
  }
  for (final pattern in _sensitivePatterns) {
    if (pattern.hasMatch(lower)) {
      return true;
    }
  }
  return false;
}

Map<String, dynamic> redactSensitiveFields(Map<String, dynamic> payload) {
  return payload.map((key, value) {
    if (_isSensitive(key)) {
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
    if (item is Map<String, dynamic>) {
      return redactSensitiveFields(item);
    }
    if (item is List) {
      return _redactList(item);
    }
    return item;
  }).toList();
}
