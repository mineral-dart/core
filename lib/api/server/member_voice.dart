final class MemberVoice {
  final bool isDeaf;
  final bool isMute;

  MemberVoice({
    required this.isDeaf,
    required this.isMute,
  });

  factory MemberVoice.fromJson(Map<String, dynamic> json) {
    return MemberVoice(
      isDeaf: json['deaf'] ?? false,
      isMute: json['mute'] ?? false,
    );
  }
}
