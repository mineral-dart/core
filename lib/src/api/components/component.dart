enum ComponentType {
  actionRow(1),
  button(2),
  selectMenu(3),
  textInput(4);

  final int value;
  const ComponentType(this.value);

  @override
  String toString () => value.toString();
}

class Component {
  ComponentType type;
  // List<Component> components;

  Component({ required this.type });

  dynamic toJson () {}

  factory Component.from({ required dynamic payload }) {
    // List<Component> components = [];
    // for (dynamic element in payload['components']) {
    //   Component component = Component.from(payload: element);
    //   components.add(component);
    // }

    return Component(
      type: ComponentType.values.firstWhere((element) => element.value == payload['type']),
    );
  }
}
