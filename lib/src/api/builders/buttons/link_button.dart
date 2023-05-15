import 'package:mineral/core/builders.dart';

/// LinkButton component
class LinkButton extends ButtonBuilder {
  LinkButton(String url, {
    super.label,
    super.emoji,
    super.disabled = false,
  }): super(null, url: url, style: ButtonStyle.link);
}