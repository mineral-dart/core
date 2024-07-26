import 'package:mineral/domains/commands/command_builder.dart';

abstract interface class CommandContract<T extends CommandBuilder> {
  T build();
}
