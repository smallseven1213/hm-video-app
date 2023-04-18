import 'package:get/get.dart';

import '../apis/event_api.dart';
import '../models/event.dart';
import 'auth_controller.dart';
import 'user_controller.dart';

class EventController extends GetxController {
  List<Event> data = <Event>[].obs;

  @override
  void onInit() async {
    super.onInit();
    fetchBanner();

    Get.find<AuthController>().token.listen((event) {
      fetchBanner();
    });
  }

  Future<void> fetchBanner() async {
    EventApi eventApi = EventApi();
    var result = await eventApi.getEvents();

    data.addAll(result);
  }

  // deleteIds
  void deleteEvents(List<int> ids) async {
    EventApi eventApi = EventApi();
    eventApi.deleteEvents(ids);
    data.removeWhere((element) => ids.contains(element.id));
  }
}
