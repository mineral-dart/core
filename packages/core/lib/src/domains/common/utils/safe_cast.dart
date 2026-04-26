import 'package:mineral/src/infrastructure/io/exceptions/serialization_exception.dart';

/// Casts [value] to [T] without throwing a [TypeError] on mismatch.
///
/// Discord and inter-isolate boundaries occasionally deliver payloads whose
/// shape diverges from what the framework expects (API drift, partial
/// outage, malformed gateway frame). A bare `value as T` raises [TypeError]
/// which is an [Error] — it bypasses `on Exception` handlers and tears down
/// the shard. Routing through [SerializationException] keeps these failures
/// recoverable.
T safeCast<T>(dynamic value, {required String context}) {
  if (value is T) {
    return value;
  }
  throw SerializationException(
    'Expected $T for $context, got ${value.runtimeType}',
  );
}
