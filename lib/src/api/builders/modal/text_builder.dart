import 'package:mineral/src/api/builders/modal/input_builder.dart';
import 'package:mineral/src/api/builders/modal/text_input_style.dart';

class TextBuilder extends InputBuilder {
  TextBuilder(String customId): super(customId, TextInputStyle.input);
}