import 'package:mineral/core/builders.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/builders/menus/select_menu_builder.dart';
import 'package:mineral/src/exceptions/too_many_exception.dart';

import 'buttons/contracts/button_contract.dart';

class ComponentBuilder {
  final List<RowBuilder> rows = [];

  ComponentBuilder();

  void withSelectMenu<T extends SelectMenuBuilder> (T menu) {
    rows.add(RowBuilder([menu]));
  }

  ButtonWrapper get withButton => ButtonWrapper(this);
}

class ButtonWrapper {
  final ComponentBuilder _builder;

  ButtonWrapper(this._builder);

  void only<T extends ButtonContract> (T builder) {
    _builder.rows.add(RowBuilder([builder as ComponentWrapper]));
  }

  void many<T extends ButtonContract> (List<T> builders) {
    if (builders.length > 5) {
      throw TooManyException("You can't define more than 5 embeds in the same action-row");
    }
    
    _builder.rows.add(RowBuilder(builders));
  }
}