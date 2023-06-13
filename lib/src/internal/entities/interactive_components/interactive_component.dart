import 'package:mineral/framework.dart';
import 'package:mineral_contract/mineral_contract.dart';

abstract class InteractiveComponent<T, I extends Event> implements InteractiveComponentContract<T, I> {
  @override
  String customId;

  InteractiveComponent(this.customId);

  @override
  Future<void> handle (I interaction);

  @override
  T build ();
}