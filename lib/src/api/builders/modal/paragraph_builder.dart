import 'package:mineral/src/api/builders/modal/input_builder.dart';
import 'package:mineral/src/api/builders/modal/text_input_style.dart';

/// A builder for paragraph input component.
class ParagraphBuilder extends InputBuilder {
  ParagraphBuilder(String customId): super(customId, TextInputStyle.input);
}