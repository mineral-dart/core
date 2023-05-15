import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/builders/menus/select_menu_builder.dart';
import 'package:mineral/src/exceptions/too_many_exception.dart';

/// A builder for component entry class.
class ComponentBuilder {
  final List<RowBuilder> rows = [];

  ComponentBuilder();

  /// Add a select menu to the component.
  void withSelectMenu<T extends SelectMenuBuilder> (T menu) {
    rows.add(RowBuilder([menu]));
  }

  /// Add a button to the component.
  ButtonWrapper get withButton => ButtonWrapper(this);
}

/// A wrapper for button entry class.
class ButtonWrapper {
  final ComponentBuilder _builder;

  ButtonWrapper(this._builder);

  /// Add one button to the component.
  void only<T extends ButtonBuilder> (T builder) {
    _builder.rows.add(RowBuilder([builder]));
  }

  /// Add many buttons to the component.
  void many<T extends ButtonBuilder> (List<T> builders) {
    if (builders.length > 5) {
      throw TooManyException("You can't define more than 5 embeds in the same action-row");
    }
    
    _builder.rows.add(RowBuilder(builders));
  }
}