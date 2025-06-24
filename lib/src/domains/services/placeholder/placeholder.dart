abstract interface class PlaceholderContract {
  Map<String, dynamic> get values;

  String? get identifier;

  String apply(String value);
}
