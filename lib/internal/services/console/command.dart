import 'package:mineral/internal/services/console/command_option.dart';
import 'package:mineral/internal/services/console/option_bucket.dart';

abstract interface class CommandContract {}

abstract class Command implements CommandContract {
  final String name;
  final String? description;
  late final OptionContract options;

  Command({ required this.name, this.description, List<CommandOption> options = const [] }) {
    this.options = OptionBucket(options);
  }

  Future<void> handle ();
}