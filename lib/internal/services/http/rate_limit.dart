enum RateLimit {
  xRateLimitBucket('x-ratelimit-bucket'),
  xRateLimitLimit('x-ratelimit-limit'),
  xRateLimitRemaining('x-ratelimit-remaining'),
  xRateLimitReset('x-ratelimit-reset'),
  xRateLimitResetAfter('x-ratelimit-reset-after'),
  xRateLimitGlobal('x-ratelimit-global'),
  retryAfter('retry-after');

  final String value;
  const RateLimit(this.value);
}
