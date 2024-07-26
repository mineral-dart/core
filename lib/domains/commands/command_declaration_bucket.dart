import 'package:mineral/api/common/commands/builder/command_declaration_builder.dart';
import 'package:mineral/domains/commands/command_context.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';

final class CommandBucket {
  final KernelContract _kernel;

  CommandBucket(this._kernel);

  void declare<T extends CommandContext>(Function(CommandDeclarationBuilder) fn) {
    final builder = CommandDeclarationBuilder<T>();
    fn(builder);

    _kernel.commands.addCommand(builder);
  }
}
