abstract class PackageContract {
  final String packageName;

  PackageContract({ required this.packageName });

  Future<void> init ();
  Future<void> configure();
}