import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../controllers/system_config_controller.dart';
import '../models/event.dart';
import '../utils/fetcher.dart';

final logger = Logger();

class EventApi {
  static final EventApi _instance = EventApi._internal();

  EventApi._internal();

  factory EventApi() {
    return _instance;
  }

  final SystemConfigController _systemConfigController =
      Get.find<SystemConfigController>();

  String get apiHost => _systemConfigController.apiHost.value!;
  String get apiPrefix => '$apiHost/public/events';

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
        url: '$apiPrefix/event?id=${ids.join(',')}', method: 'delete');
  }
}
