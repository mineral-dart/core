import 'package:collection/collection.dart';
import 'package:mineral/api/common/types/enhanced_enum.dart';

T? createOrNull<T>({required dynamic field, required T? Function() fn}) =>
    field != null ? fn() : null;

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
