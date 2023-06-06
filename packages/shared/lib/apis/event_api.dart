import 'package:logger/logger.dart';

import '../models/event.dart';
import '../services/system_config.dart';
import '../utils/fetcher.dart';

final logger = Logger();
final systemConfig = SystemConfig();
String apiPrefix = '${systemConfig.apiHost}/public/events';

class EventApi {
  static final EventApi _instance = EventApi._internal();

  EventApi._internal();

  factory EventApi() {
    return _instance;
  }

  Future<List<Event>> getEvents() async {
    var res = await fetcher(url: '$apiPrefix/event/list');
    if (res.data['code'] != '00') {
      return [];
    }
    return List<Event>.from(
        res.data['data'].map((v) => Event.fromJson(v)).toList());
  }

  void deleteEvents(List<int> ids) async {
    await fetcher(
        url: '$apiPrefix/event/id=${ids.join(',')}', method: 'delete');
  }
}
