import 'package:shared/helpers/getField.dart';

import 'command.dart';

class LiveRoom {
  String chattoken;
  int pid;
  int hid;
  bool follow;
  String pullurl;
  double amount;
  List<Command> commands;
  String? pullUrlDecode;

  LiveRoom(
      {required this.chattoken,
      required this.pid,
      required this.hid,
      required this.pullurl,
      required this.commands,
      this.follow = false,
      this.amount = 0,
      this.pullUrlDecode});

  factory LiveRoom.fromJson(Map<String, dynamic> json) {
    var follow = json['follow'];
    return LiveRoom(
        chattoken: getField(json, 'chattoken', defaultValue: ''),
        pid: getField(json, 'pid', defaultValue: 0),
        hid: getField(json, 'hid', defaultValue: 0),
        pullurl: getField(json, 'pullurl', defaultValue: ''),
        amount: getField(json, 'amount', defaultValue: 0),
        commands: getField(json, 'commands', defaultValue: [])
            .map<Command>((e) => Command.fromJson(e))
            .toList(),
        follow: follow);
  }

  Map<String, dynamic> toJson() {
    return {
      'chattoken': chattoken,
      'pid': pid,
      'pullurl': pullurl,
      'amount': amount,
      'follow': follow,
      'hid': hid,
      'commands': commands.map((e) => e.toJson()).toList(),
    };
  }
}
