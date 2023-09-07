import 'package:mineral/internal/services/intents/intent.dart';
import 'package:mineral/internal/services/intents/intents.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main () {
  test('can create Intent service with all intents', () {
    final Intents service = Intents.all();
    expect(service.intents, hasLength(19));
  });

  test('can create Intent service with all defined intents', () {
    final Intents service = Intents.only([Intent.guilds, Intent.autoModerationConfiguration]);
    expect(service.intents, allOf([
      hasLength(2),
      containsAll([Intent.guilds, Intent.autoModerationConfiguration])
    ]));
  });

  test('can create Intent service with all defined intents from builder', () {
    final Intents service = Intents.builder(
      (builder) => builder
        .guilds()
        .autoModerationConfiguration()
        .autoModerationExecution()
    );

    expect(service.intents, allOf([
      hasLength(3),
      containsAll([
        Intent.guilds,
        Intent.autoModerationConfiguration,
        Intent.autoModerationExecution
      ])
    ]));
  });

  test('can create Intent service without intents', () {
    final Intents service = Intents.none();
    expect(service.intents, isEmpty);
  });
}