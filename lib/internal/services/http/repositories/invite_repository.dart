/// Repository for [Invite] service
/// Related official [documentation](https://discord.com/developers/docs/resources/invite)
final class InviteRepository {
  /// Get one invite from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/invite#get-invite)
  /// ```dart
  /// final uri = http.endpoints.invites.one('1234');
  /// ```
  String one({ required String inviteCode }) =>
      Uri(pathSegments: ['invites', inviteCode]).path;

  /// Delete one invite from Discord API.
  /// Related [official documentation](https://discord.com/developers/docs/resources/invite#delete-invite)
  /// ```dart
  /// final uri = http.endpoints.invites.delete('1234');
  /// ```
  String delete({ required String inviteCode }) =>
      Uri(pathSegments: ['invites', inviteCode]).path;
}