enum ClientScope {
  activitiesRead('activities.read'),
  activitiesWrite('activities.write'),
  applicationBuildsRead('applications.builds.read'),
  applicationBuildsUpload('applications.builds.upload'),
  applicationsCommands('applications.commands'),
  applicationsCommandsUpdate('applications.commands.update'),
  applicationsCommandsPermissionsUpdate('applications.commands.permissions.update'),
  applicationEntitlements('applications.entitlements'),
  applicationsStoreUpdate('applications.store.update'),
  bot('bot'),
  connections('connections'),
  dmChannelsRead('dm_channels.read'),
  email('email'),
  gdmJoin('gdm.join'),
  guilds('guilds'),
  guildsJoin('guilds.join'),
  guildsMembersRead('guilds.members.read'),
  identify('identify'),
  messagesRead('messages.read'),
  relationships('relationships.read'),
  roleConnectionsWrite('role_connections.write'),
  rpc('rpc'),
  rpcActivitiesWrite('rpc.activities.write'),
  rpcNotificationsRead('rpc.notifications.read'),
  rpcVoiceRead('rpc.voice.read'),
  rpcVoiceWrite('rpc.voice.write'),
  voice('voice'),
  webhookIncoming('webhook.incoming');

  final String value;
  const ClientScope(this.value);
}