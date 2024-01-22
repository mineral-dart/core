import 'package:mineral/application/environment/environment.dart';
import 'package:mineral/application/placeholder/placeholder.dart';
import 'package:recase/recase.dart';

final class EnvironmentPlaceholder implements PlaceholderContract {
  final Map<String, dynamic> _values = {};

  @override
  String get identifier => 'env';

  @override
  Map<String, dynamic> get values => _values;

  EnvironmentPlaceholder({required EnvironmentContract environment}) {
    _injectEntryMap(identifier, environment.list);
  }

  void _injectEntryMap(String identifier, Map<String, dynamic> values) {
    final mapEntry = Map<String, dynamic>.from(values.map((key, value) {
      final currentKey = key.snakeCase.toUpperCase();
      return MapEntry('$identifier.$currentKey', value);
    }));

    _values.addAll(mapEntry);
  }

  @override
  String apply(String value) => values.entries.fold(value, (acc, element) {
        final finalValue = switch (element.value) {
          String() => element.value,
          int() => element.value.toString(),
          _ => throw Exception('Invalid type')
        };

        return acc
          .replaceAll('{${element.key}}', finalValue)
          .replaceAll('{{ ${element.key} }}', finalValue);
      });
}
