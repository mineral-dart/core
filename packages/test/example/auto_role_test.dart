import 'package:mineral_test/mineral_test.dart';
import 'package:test/test.dart';

import 'src/auto_role_listener.dart';

void main() {
  group('AutoRoleListener', () {
    late TestBot bot;
    late TestGuild guild;
    late TestRole memberRole;

    setUp(() async {
      bot = await TestBot.create();
      guild = GuildBuilder().withName('Auto-Role Server').build();
      memberRole = RoleBuilder().withName('Member').ofGuild(guild).build();
      AutoRoleConfig.roleIdsByGuild[guild.id] = memberRole.id;

      bot.dataStore.seed(guilds: [guild], roles: [memberRole]);
      bot.events.register(AutoRoleListener());
    });

    tearDown(() async {
      AutoRoleConfig.roleIdsByGuild.clear();
      await bot.dispose();
    });

    test('assigns the configured role to a newcomer', () async {
      final user = UserBuilder().withUsername('newbie').build();
      final member = MemberBuilder().ofGuild(guild).withUser(user).build();
      bot.dataStore.seed(members: [member]);

      await bot.simulateMemberJoin(member: member, guild: guild);

      expect(
        bot.actions.roleAssignments,
        contains(isRoleAssigned(memberId: member.id, roleId: memberRole.id)),
      );

      // The data-store façade picked up the recorded action: the member now
      // has the role attached when re-read from the store.
      final updated = bot.dataStore.member(member.id, in_: guild);
      expect(updated.roles, contains(memberRole));
    });

    test('logs a warning and does nothing if no role is configured', () async {
      AutoRoleConfig.roleIdsByGuild.clear();
      final user = UserBuilder().withUsername('orphan').build();
      final member = MemberBuilder().ofGuild(guild).withUser(user).build();
      bot.dataStore.seed(members: [member]);

      await bot.simulateMemberJoin(member: member, guild: guild);

      expect(bot.actions.roleAssignments, isEmpty);
      expect(bot.errors, isEmpty);
    });
  });
}
