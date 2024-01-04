class LiveRoom {
  String chattoken;
  int pid;
  int hid;
  bool follow;
  String pullurl;
  int amount;
  String? pullUrlDecode;

  LiveRoom(
      {required this.chattoken,
      required this.pid,
      required this.hid,
      required this.pullurl,
      this.follow = false,
      this.amount = 0,
      this.pullUrlDecode});

  factory LiveRoom.fromJson(Map<String, dynamic> json) {
    return LiveRoom(
      chattoken: json['chattoken'],
      pid: json['pid'],
      hid: int.parse(json['hid']),
      pullurl: json['pullurl'],
      amount: json['amount'],
      follow: json['follow'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chattoken': chattoken,
      'pid': pid,
      'pullurl': pullurl,
      'amount': amount,
      'follow': follow,
      'hid': hid,
    };
  }
}
