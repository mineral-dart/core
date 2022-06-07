import 'package:mineral/src/api/components/component.dart';

class Link extends Component {
  String label;
  String url;
  int style = 5;

  Link({ required this.label, required this.url }) : super(type: ComponentType.button);

  @override
  dynamic toJson () {
    return {
      'type': type.value,
      'label': label,
      'style': style,
      'url': url,
    };
  }

  factory Link.from({ required dynamic payload }) {
    return Link(
      url: payload['url'],
      label: payload['label'],
    );
  }
}
