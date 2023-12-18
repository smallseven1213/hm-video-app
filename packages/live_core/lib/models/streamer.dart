class Streamer {
  final int id;
  final String? account;
  final String? nickname;

  Streamer({
    required this.id,
    this.account,
    this.nickname,
  });

  factory Streamer.fromJson(Map<String, dynamic> json) {
    print('@@@json: $json');
    return Streamer(
      id: json['id'],
      account: json['account'],
      nickname: json['nickname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account': account,
      'nickname': nickname,
    };
  }
}
