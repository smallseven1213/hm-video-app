import 'package:get/get.dart';

import '../apis/event_api.dart';
import '../models/event.dart';

class EventController extends GetxController {
  var data = <Event>[].obs;
  var hasUnRead = false.obs;

  Future<void> fetchData() async {
    EventApi eventApi = EventApi();
    var result = await eventApi.getEvents();
    data.value = result;
    if (result.any((element) => element.isRead == false)) {
      hasUnRead.value = true;
    }
  }

  void markAllAsRead() async {
    hasUnRead.value = false;
  }

  // deleteIds
  void deleteEvents(List<int> ids) async {
    EventApi eventApi = EventApi();
    eventApi.deleteEvents(ids);
    data.removeWhere((element) => ids.contains(element.id));
  }
}
