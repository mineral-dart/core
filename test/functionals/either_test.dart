import 'package:mineral/internal/either.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main () {
  test('handle failure when Error was emitted', () async {
    final String errorMessage = 'Error message';

    final either = await Either.future<dynamic, String>(
      future: Future.error(errorMessage)
    );

    expect(either, isA<Failure>());
    expect((either as Failure).error, allOf([
      isA<String>(),
      equals(errorMessage)
    ]));
  });

  test('handle failure when Error was emitted with throw error', () async {
    final String errorMessage = 'Error message';

    final future = Either.future<dynamic, String>(
      future: Future.error(errorMessage),
      onError: (failure) => throw Error.throwWithStackTrace(Exception(failure.error), failure.stackTrace!)
    );

    await expectLater(future, throwsA(isA<Exception>()));
  });

  test('handle success when Error was not emitted', () async {
    final String successMessage = 'Success message';

    final either = await Either.future<String, dynamic>(
      future: Future.value(successMessage),
    );

    expect(either, isA<Success>());
    expect((either as Success).value, equals(successMessage));
  });
}