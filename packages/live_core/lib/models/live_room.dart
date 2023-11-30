class LiveRoom {
  final String chattoken;
  final int pid;
  final String pullurl;
  String? pullUrlDecode;

  LiveRoom(
      {required this.chattoken,
      required this.pid,
      required this.pullurl,
      this.pullUrlDecode});

  factory LiveRoom.fromJson(Map<String, dynamic> json) {
    return LiveRoom(
      chattoken: json['chattoken'],
      pid: json['pid'],
      pullurl: json['pullurl'],
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
