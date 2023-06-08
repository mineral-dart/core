class OptionChoice {
  final String label;
  final String value;

  const OptionChoice({ required this.label, required this.value });

  Map<String, dynamic> get serialize => {
    'name': label,
    'value': value
  };
}
