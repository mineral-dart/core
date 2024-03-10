import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mineral/api/common/types/enhanced_enum.dart';

FutureOr<T?> createOrNull<T>({required dynamic field, required FutureOr<T?> Function() fn}) async =>
    field != null ? await fn() : null;

List<T> bitfieldToList<T extends EnhancedEnum<int>>(List<T> values, int bitfield) {
  final List<T> flags = [];

  for (final element in values) {
    if ((bitfield & element.value) == element.value) {
      flags.add(element);
    }
  }
  return flags;
}

T findInEnum<T extends EnhancedEnum<R>, R>(List<T> values, R value) {
  return values.firstWhereOrNull((element) => element.value == value) as T;
}

void expectOrThrow(bool value, {String? message}) {
  if (!value) {
    throw Exception(message);
  }
}
