import 'package:mineral/src/domains/contracts/environment/env_schema.dart';

abstract interface class EnvContract {
  Map<String, String> get list;

  T get<T>(EnvSchema variable);

  void validate(List<EnvSchema> values);
}
