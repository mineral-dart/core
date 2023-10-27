final class CommandOption {
  final String name;
  final String description;
  final String? usage;
  final String? abbr;
  dynamic value;

  CommandOption({
    required this.name,
    required this.description,
    this.usage,
    this.abbr,
    this.value,
  });
}