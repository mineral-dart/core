import 'package:mineral/api/common/channel.dart';
import 'package:mineral/api/common/channel_permission_overwrite.dart';
import 'package:mineral/api/common/embed/message_embed.dart';
import 'package:mineral/api/common/emoji.dart';
import 'package:mineral/api/common/polls/poll.dart';
import 'package:mineral/api/common/sticker.dart';
import 'package:mineral/api/private/private_message.dart';
import 'package:mineral/api/private/user.dart';
import 'package:mineral/api/server/channels/thread_channel.dart';
import 'package:mineral/api/private/user_assets.dart';
import 'package:mineral/api/server/member.dart';
import 'package:mineral/api/server/member_assets.dart';
import 'package:mineral/api/server/role.dart';
import 'package:mineral/api/server/server.dart';
import 'package:mineral/api/server/server_assets.dart';
import 'package:mineral/api/server/server_message.dart';
import 'package:mineral/api/server/server_settings.dart';
import 'package:mineral/api/server/server_subscription.dart';
import 'package:mineral/infrastructure/internals/marshaller/marshaller.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/channel_permission_overwrite_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/channel_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/embed_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/emoji_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/member_assets_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/member_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/poll_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/private_message_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/role_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_assets_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_message_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_settings_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/server_subscription_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/sticker_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/user_assets_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/thread_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/serializers/user_serializer.dart';
import 'package:mineral/infrastructure/internals/marshaller/types/serializer.dart';

final class SerializerBucket {
  final SerializerContract<Channel> channels;

  final SerializerContract<Server> server;

  final SerializerContract<Member> member;

  final SerializerContract<MemberAssets> memberAssets;

  final SerializerContract<User> user;

  final SerializerContract<UserAssets> userAssets;

  final SerializerContract<Role> role;

  final SerializerContract<ServerSubscription> serverSubscription;

  final SerializerContract<ServerSettings> serverSettings;

  final SerializerContract<ServerAsset> serversAsset;

  final SerializerContract<Emoji> emojis;

  final SerializerContract<Sticker> sticker;

  final SerializerContract<ChannelPermissionOverwrite> channelPermissionOverwrite;

  final SerializerContract<ServerMessage> serverMessage;

  final SerializerContract<PrivateMessage> privateMessage;

  final SerializerContract<MessageEmbed> embed;

  final SerializerContract<Poll> poll;

  final SerializerContract<ThreadChannel> thread;

  SerializerBucket(MarshallerContract marshaller)
      : channels = ChannelSerializer(marshaller),
        server = ServerSerializer(marshaller),
        member = MemberSerializer(marshaller),
        memberAssets = MemberAssetsSerializer(marshaller),
        user = UserSerializer(marshaller),
        userAssets = UserAssetsSerializer(marshaller),
        role = RoleSerializer(marshaller),
        serverSubscription = ServerSubscriptionSerializer(marshaller),
        serverSettings = ServerSettingsSerializer(marshaller),
        serversAsset = ServerAssetsSerializer(marshaller),
        emojis = EmojiSerializer(marshaller),
        sticker = StickerSerializer(marshaller),
        channelPermissionOverwrite = ChannelPermissionOverwriteSerializer(marshaller),
        serverMessage = ServerMessageSerializer(marshaller),
        privateMessage = PrivateMessageSerializer(marshaller),
        embed = EmbedSerializer(marshaller),
        thread = ThreadSerializer(marshaller),
        poll = PollSerializer(marshaller);
}
