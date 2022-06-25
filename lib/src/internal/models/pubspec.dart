import 'package:yaml/yaml.dart';

class Pubspec {
  String name;
  String version;
  String description;
  String? homepage;
  String? repository;
  String? issueTracker;
  String? documentation;
  YamlMap? dependencies;
  YamlMap? devDependencies;
  YamlMap? dependencyOverrides;
  List<String> publishTo;
  List<String> falseSecrets;

  Pubspec({
    required this.name,
    required this.version,
    required this.description,
    required this.homepage,
    required this.repository,
    required this.issueTracker,
    required this.documentation,
    required this.dependencies,
    required this.devDependencies,
    required this.dependencyOverrides,
    required this.publishTo,
    required this.falseSecrets,
  });

  factory Pubspec.from({ required dynamic payload }) {
    return Pubspec(
      name: payload['name'],
      version: payload['version'],
      description: payload['description'],
      homepage: payload['homepage'],
      repository: payload['repository'],
      issueTracker: payload['issue_tracker'],
      documentation: payload['documentation'],
      dependencies: payload['dependencies'],
      devDependencies: payload['dev_dependencies'],
      dependencyOverrides: payload['dependency_overrides'],
      publishTo: payload['publish_to'] ?? [],
      falseSecrets: payload['false_secrets'] ?? []
    );
  }
}
