import 'package:mineral/api/common/types/flag.dart';

T? createOrNull<T>({ required dynamic field, required T? Function() fn }) => field != null ? fn() : null;

List<T> bitfieldToList<T extends Flag> (List<T> values, int bitfield) {
  final List<T> flags = [];

  for (final element in values) {
    if ((bitfield & element.value) == element.value) {
      flags.add(element);
    }
  }
  return flags;
}
