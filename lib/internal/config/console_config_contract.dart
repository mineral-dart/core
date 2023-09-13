import 'package:mineral/internal/console/command.dart';

abstract class ConsoleConfigContract {
  final List<Command> commands;

  ConsoleConfigContract(this.commands);
}