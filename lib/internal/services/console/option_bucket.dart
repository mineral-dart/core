import 'package:mineral/internal/services/console/command_option.dart';

abstract class OptionContract {
  T get<T>(String key);
  List<CommandOption> get bucket;
}

final class OptionBucket implements OptionContract {
  final List<CommandOption> options;

  @override
  List<CommandOption> get bucket => options;

  OptionBucket(this.options);

  @override
  T get<T>(String key) {
    final option = options.firstWhere((element) => element.name == key);
    return switch (T) {
      int => int.parse(option.value),
      double => double.parse(option.value),
      String => option.value,
      bool => option.value == 'true',
      _ => option.value,
    } as T;
  }
}