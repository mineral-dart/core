import 'package:mineral/core/api.dart';
import 'package:mineral/src/api/builders/component_wrapper.dart';
import 'package:mineral/src/api/builders/menus/select_menu_builder.dart';

class ChannelSelectMenuBuilder extends SelectMenuBuilder {
  List<ChannelType> channels = [];
  ChannelSelectMenuBuilder(String customId) : super (customId, ComponentType.channelSelect);

  void setChannelTypes (List<ChannelType> types) {
    channels.addAll(types);
  }

  @override
  Map<String, dynamic> toJson () => {
    ...super.toJson(),
    'channel_types': channels.map((element) => element.value).toList(),
  };
}