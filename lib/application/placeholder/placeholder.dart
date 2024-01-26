abstract interface class PlaceholderContract {
  Map<String, dynamic> get values;

  String? get identifier;

  String apply(String value);
}

class Placeholder implements PlaceholderContract {
  final Map<String, dynamic> _values = {};

  @override
  final String? identifier;

  @override
  Map<String, dynamic> get values => _values;

  Placeholder({this.identifier, Map<String, dynamic>? values}) {
    if (values != null) {
      _injectEntryMap(identifier, values);
    }
  }

  void _injectEntryMap(String? identifier, Map<String, dynamic> values) {
    final mapEntry = Map<String, dynamic>.from(values.map((key, value) {
      final hasIdentifier = key.contains('.');
      final finalKey = !hasIdentifier
          ? identifier != null
              ? '$identifier.$key'
              : key
          : key;

      return MapEntry(finalKey, value);
    }));

    _values.addAll(mapEntry);
  }

  void merge(PlaceholderContract placeholder) {
    _injectEntryMap(placeholder.identifier, placeholder.values);
  }

  @override
  String apply(String value, {Map<String, dynamic>? values}) {
    String finalValue = value;
    if (values != null) {
      final currentValues = Map<String, dynamic>.from(values.map((key, value) =>
          identifier != null ? MapEntry('$identifier.$key', value) : MapEntry(key, value)));

      finalValue = replace(value, currentValues);
    }

    return replace(finalValue, this.values);
  }

  String replace(String value, Map<String, dynamic> map) {
    return map.entries.fold(value, (acc, element) {
      final finalValue = switch (element.value) {
        String() => element.value,
        int() => element.value.toString(),
        _ => throw Exception('Invalid type')
      };

      return acc
        .replaceAll('{{${element.key}}}', finalValue)
        .replaceAll('{{ ${element.key} }}', finalValue);
    });
  }

// @override
// String apply(String value, { Map<String, dynamic>? values }) => (values ?? this.values).entries.fold(value, (acc, element) {
//   print(element.key);
//
//   final finalValue = switch (element.value) {
//     String() => element.value,
//     int() => element.value.toString(),
//     _ => throw Exception('Invalid type')
//   };
//
//   return acc.replaceAll('{${element.key}}', finalValue);
// });
}
