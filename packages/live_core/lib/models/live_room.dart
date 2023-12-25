class LiveRoom {
  final String chattoken;
  final int pid;
  final String pullurl;
  int amount;
  String? pullUrlDecode;

  LiveRoom(
      {required this.chattoken,
      required this.pid,
      required this.pullurl,
      this.amount = 0,
      this.pullUrlDecode});

  factory LiveRoom.fromJson(Map<String, dynamic> json) {
    return LiveRoom(
      chattoken: json['chattoken'],
      pid: json['pid'],
      pullurl: json['pullurl'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chattoken': chattoken,
      'pid': pid,
      'pullurl': pullurl,
    };
  }
}
