import 'package:mineral/domains/data/functional_event_registrar.dart';
import 'package:mineral/domains/data/types/listenable_event.dart';
import 'package:mineral/domains/shared/types/kernel_contract.dart';

abstract interface class MineralClientContract {
  KernelContract get kernel;
  FunctionalEventRegistrarContract get fn;

  void register(ListenableEvent Function() event);

  Future<void> init();
}
