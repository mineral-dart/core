import 'package:mineral/domains/events/functional_event_registrar.dart';
import 'package:mineral/domains/kernel/types/kernel_contract.dart';

abstract interface class MineralClientContract {
  KernelContract get kernel;
  FunctionalEventRegistrarContract get fn;

  Future<void> init();
}
