import 'package:mineral/core/builders.dart';

/// A field in an [EmbedBuilder].
class EmbedField {
  /// The name of this.
  String name;

  /// The value of this.
  String value;

  /// Whether or not this field should display inline.
  bool? inline;

  EmbedField({ required this.name, required this.value, this.inline });

  /// Converts the [EmbedField] to a [Map] that can be serialized to JSON.
  Object toJson () => {
    'name': name,
    'value': value,
    'inline': inline ?? false,
  };
}