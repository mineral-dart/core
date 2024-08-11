import 'package:mineral/api/common/commands/command_contract.dart';
import 'package:mineral/domains/commands/command_declaration_bucket.dart';
import 'package:mineral/domains/events/contracts/server/server_channel_select_event.dart';
import 'package:mineral/domains/events/contracts/server/server_dialog_submit_event.dart';
import 'package:mineral/domains/events/contracts/server/server_member_select_event.dart';
import 'package:mineral/domains/events/contracts/server/server_role_select_event.dart';
import 'package:mineral/domains/events/contracts/server/server_text_select_event.dart';
import 'package:mineral/domains/events/contracts/private/private_dialog_submit_event.dart';
import 'package:mineral/domains/events/contracts/private/private_user_select_event.dart';
import 'package:mineral/domains/events/contracts/private/private_text_select_event.dart';
import 'package:mineral/domains/events/event_bucket.dart';
import 'package:mineral/domains/events/types/listenable_event.dart';
import 'package:mineral/infrastructure/commons/listenable.dart';
import 'package:mineral/infrastructure/internals/environment/environment.dart';
import 'package:mineral/infrastructure/kernel/kernel.dart';

abstract interface class MineralClientContract {
  EnvContract get environment;

  EventBucket get events;

  CommandBucket get commands;

  void register(Listenable Function() event);

  void registerCommand(CommandContract Function() command);

  Future<void> init();
}

final class MineralClient implements MineralClientContract {
  final KernelContract _kernel;

  @override
  late final EventBucket events;

  @override
  late final CommandBucket commands;

  @override
  EnvContract get environment => _kernel.environment;

  MineralClient(KernelContract kernel)
      : events = EventBucket(kernel),
        commands = CommandBucket(kernel),
        _kernel = kernel;

  @override
  void register(Listenable Function() event) {
    final instance = event();

    switch (instance) {
      case ListenableEvent():
        _kernel.eventListener.listen(
          event: instance.event,
          handle: (instance as dynamic).handle as Function,
          customId: switch(instance) {
            final ServerDialogSubmitEvent instance => instance.customId,
            final ServerChannelSelectEvent instance => instance.customId,
            final ServerRoleSelectEvent instance => instance.customId,
            final ServerMemberSelectEvent instance => instance.customId,
            final ServerTextSelectEvent instance => instance.customId,
            final PrivateDialogSubmitEvent instance => instance.customId,
            final PrivateUserSelectEvent instance => instance.customId,
            final PrivateTextSelectEvent instance => instance.customId,
            _ => null
          }
        );
    }
  }

  @override
  void registerCommand(CommandContract Function() command) {
    final instance = command();
    _kernel.commands.addCommand(instance.build());
  }

  @override
  Future<void> init() => _kernel.init();
}
