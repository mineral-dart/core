Map<String, dynamic> redactSensitiveFields(Map<String, dynamic> payload) {
  const sensitiveKeys = {'token'};
  return payload.map((key, value) {
    if (sensitiveKeys.contains(key)) {
      return MapEntry(key, '***');
    }
    if (value is Map<String, dynamic>) {
      return MapEntry(key, redactSensitiveFields(value));
    }
    return MapEntry(key, value);
  });
}
