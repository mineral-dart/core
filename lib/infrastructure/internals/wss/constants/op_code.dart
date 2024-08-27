enum OpCode {
  dispatch(0),
  heartbeat(1),
  identify(2),
  statusUpdate(3),
  voiceStateUpdate(4),
  voiceGuildPing(5),
  resume(6),
  reconnect(7),
  requestGuildMember(8),
  invalidSession(9),
  hello(10),
  heartbeatAck(11),
  guildSync(12);

  final int value;
  const OpCode(this.value);
}
