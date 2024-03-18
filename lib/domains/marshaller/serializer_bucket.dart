import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/sticker.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/api/server/server_subscription.dart';
import 'package:mineral/domains/marshaller/marshaller.dart';
import 'package:mineral/domains/marshaller/serializers/channel_permission_overwrite_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/channel_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/emoji_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/member_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/role_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/server_assets_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/server_message_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/server_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/server_settings_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/server_subscription_serializer.dart';
import 'package:mineral/domains/marshaller/serializers/sticker_serializer.dart';
import 'package:mineral/domains/marshaller/types/serializer.dart';

abstract interface class SerializerBucket {
  SerializerContract<Channel?> get channels;

  SerializerContract<Server> get server;

  SerializerContract<ServerMessage> get serverMessage;

  SerializerContract<Member> get member;

  SerializerContract<Role> get role;

  SerializerContract<ServerSubscription> get serverSubscription;

  SerializerContract<ServerSettings> get serverSettings;

  SerializerContract<ServerAsset> get serversAsset;

  SerializerContract<Emoji> get emojis;

  SerializerContract<Sticker> get sticker;

  SerializerContract<ChannelPermissionOverwrite> get channelPermissionOverwrite;
}

final class SerializerBucketImpl<T> implements SerializerBucket {
  @override
  final SerializerContract<Channel> channels;

  @override
  final SerializerContract<Server> server;

  @override
  final SerializerContract<ServerMessage> serverMessage;

  @override
  final SerializerContract<Member> member;

  @override
  final SerializerContract<Role> role;

  @override
  final SerializerContract<ServerSubscription> serverSubscription;

  @override
  final SerializerContract<ServerSettings> serverSettings;

  @override
  final SerializerContract<ServerAsset> serversAsset;

  @override
  final SerializerContract<Emoji> emojis;

  @override
  final SerializerContract<Sticker> sticker;

  @override
  SerializerContract<ChannelPermissionOverwrite> channelPermissionOverwrite;

  SerializerBucketImpl(MarshallerContract marshaller)
      : channels = ChannelSerializer(marshaller),
        server = ServerSerializer(marshaller),
        serverMessage = ServerMessageSerializer(marshaller),
        member = MemberSerializer(marshaller),
        role = RoleSerializer(marshaller),
        serverSubscription = ServerSubscriptionSerializer(marshaller),
        serverSettings = ServerSettingsSerializer(marshaller),
        serversAsset = ServerAssetsSerializer(marshaller),
        emojis = EmojiSerializer(marshaller),
        sticker = StickerSerializer(marshaller),
        channelPermissionOverwrite = ChannelPermissionOverwriteSerializer(marshaller);
}
