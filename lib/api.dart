library api;

import 'dart:convert';
import 'package:mineral/console.dart';
import 'package:mineral/helper.dart';

import 'package:http/http.dart';
import 'package:mineral/core.dart';
import 'package:mineral/src/api/managers/channel_manager.dart';
import 'package:mineral/src/api/managers/emoji_manager.dart';
import 'package:mineral/src/api/managers/guild_manager.dart';
import 'package:mineral/src/api/managers/member_manager.dart';
import 'package:mineral/src/api/managers/message_manager.dart';
import 'package:mineral/src/api/managers/role_manager.dart';
import 'package:mineral/src/api/welcome_screen.dart';

part 'src/api/mineral_client.dart';
part 'src/api/application.dart';
part 'src/api/user.dart';
part 'src/api/guild_member.dart';

part 'src/api/guild.dart';

part 'src/api/channels/channel.dart';
part 'src/api/channels/voice_channel.dart';
part 'src/api/channels/text_based_channel.dart';
part 'src/api/channels/text_channel.dart';
part 'src/api/channels/category_channel.dart';

part 'src/api/message.dart';

part 'src/api/emoji.dart';
part 'src/api/role.dart';

part 'src/api/utils.dart';

typedef Snowflake = String;
