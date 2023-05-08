import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/buttons/contracts/clickable_button_contract.dart';

/// ClickableButton component
class ClickableButton extends ButtonBuilder implements ClickableButtonContract {
  ClickableButton(super.customId, super.url, super.style);
}