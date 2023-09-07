import 'package:mineral/internal/reporter/result.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main () {
  test('handle failure when Error was emitted', () async {
    final String errorMessage = 'Error message';

    final result = await Future.error(errorMessage)
      .onError((error, stackTrace) => Failure(error, stackTrace: stackTrace));

    expect(result, isA<Failure>());
    expect(result.error, equals(errorMessage));
  });

  test('handle success when Error was not emitted', () async {
    final String successMessage = 'Success message';

    final result = await Future.value(successMessage)
      .then((String value) => Success(value));

    expect(result, isA<Success>());
    expect(result.value, equals(successMessage));
  });
}