enum ShardDisconnectError {
  normal(1000, 'Normal', false),
  goingAway(1001, 'Going away', false),
  disconnect(1002, 'Disconnect', false),
  invalidData(1003, 'Invalid contracts', false),
  policyViolation(1008, 'Policy violation', false),
  tooBig(1009, 'Message too big', false),
  extensionRequired(1010, 'Extension required', false),
  unexpectedCondition(1011, 'Unexpected condition', false),
  serviceRestart(1012, 'Service restart', false),
  tryAgainLater(1013, 'Try again later', false),
  invalidTls(1015, 'Invalid TLS', false),
  unknownError(4000,	'Unknown error', true),
  unknownOpCode(4001,	'Unknown opcode',	true),
  decodeError(4002,	'Decode error',	true),
  notAuthenticated(4003,	'Not authenticated', true),
  authenticationFailed(4004,	'Authentication failed', false),
  alreadyAuthenticated(4005,	'Already authenticated', true),
  invalidSequence(4007,	'Invalid sequence',	true),
  rateLimited(4008,	'Rate limited', true),
  sessionTimeout(4009,	'Session timed out', true),
  invalidShard(4010,	'Invalid shard', false),
  shardingRequired(4011,	'Sharding required', false),
  invalidApiVersion(4012,	'Invalid API version', false),
  invalidIntents(4013,	'Invalid intent(s)', false),
  disallowedIntents(4014,	'Disallowed intent(s)',	false);

  final int code;
  final String message;
  final bool canBeReconnected;

  const ShardDisconnectError(this.code, this.message, this.canBeReconnected);
}
