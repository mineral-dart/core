import 'package:mineral/internal/services/console/command.dart';

abstract class ConsoleConfigContract {
  final List<Command> commands;

  ConsoleConfigContract(this.commands);
}