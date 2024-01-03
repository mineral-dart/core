enum ExplicitContentFilter {
  disabled(0),
  membersWithoutRoles(1),
  allMembers(2);

  final int value;
  const ExplicitContentFilter(this.value);
}
