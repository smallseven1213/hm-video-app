import 'package:shared/helpers/get_field.dart';

import 'command.dart';

class Language {
  String code;
  String name;

  Language({required this.code, required this.name});

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}

class LiveRoom {
  String chattoken;
  int pid;
  int hid;
  bool follow;
  String pullurl;
  double amount;
  List<Command> commands;
  String? pullUrlDecode;
  List<Language> languages = [];

  LiveRoom(
      {required this.chattoken,
      required this.pid,
      required this.hid,
      required this.pullurl,
      required this.commands,
      required this.languages,
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
        languages: getField(json, 'languages', defaultValue: [])
            .map<Language>((e) => Language.fromJson(e))
            .toList(),
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
      'languages': languages.toList(),
    };
  }
}
