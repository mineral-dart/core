abstract interface class DiscordNetworkError {
  void dispatch(Map<String, dynamic> payload);
}

final class DiscordNetworkErrorImpl implements DiscordNetworkError {
  @override
  void dispatch(Map<String, dynamic> payload) {

    return switch (payload['code']) {
      _ => print('Unknown error !'),
    };
  }
}
