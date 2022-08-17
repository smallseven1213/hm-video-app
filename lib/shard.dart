
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wgp_video_h5app/models/event.dart';

import 'models/position.dart';


class SharedPreferencesUtil {

  static final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static Future<List<Position>> getPositions(int id) async {
    final SharedPreferences prefs = await _prefs;
    var positions = jsonDecode(prefs.getString(id.toString())!) as List<dynamic>;
    return List.from((positions).map((e) => Position.fromJson(e)));
  }

  static Future<bool> setPositions(int id, List<dynamic> value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(id.toString(), jsonEncode(value));
  }

  static Future<bool> setEventLatest(List<dynamic> value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString("EVENT_LATEST", jsonEncode(value));
  }

  static Future<bool> hasEventLatest() async {
    final SharedPreferences prefs = await _prefs;
    if (prefs.getString("EVENT_LATEST") == null) {
      return Future.value(false);
    }
    var positions = jsonDecode(prefs.getString("EVENT_LATEST")!) as List<dynamic>;
    return positions.isNotEmpty;
  }

  static Future<Set<String>> getAll() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getKeys();
  }

}