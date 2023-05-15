import 'package:mineral/core/builders.dart';

/// ClickableButton component
class ClickableButton extends ButtonBuilder {
  ClickableButton(String customId, {
    super.label,
    super.style = ButtonStyle.primary,
    super.emoji,
    super.disabled = false,
  }): super(customId);
}