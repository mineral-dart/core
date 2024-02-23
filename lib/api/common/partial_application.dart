final class PartialApplication {
  final String id;
  final int flags;

  const PartialApplication({
    required this.id,
    required this.flags,
  });

  factory PartialApplication.fromJson(Map<String, dynamic> json) {
    return PartialApplication(
      id: json['id'],
      flags: json['flags'],
    );
  }
}
