// EventController is getx controller , save event data
// source data is from EventApi.getEvents()

import 'package:get/get.dart';

import '../apis/event_api.dart';

class MockItem {
  String title;
  int id;
  String content;

  MockItem({required this.title, required this.id, required this.content});
}

class EventController extends GetxController {
  RxList<MockItem> data = RxList<MockItem>();

  @override
  void onInit() async {
    super.onInit();
    fetchBanner();
  }

  Future<void> fetchBanner() async {
    // EventApi eventApi = EventApi();
    // var result = await eventApi.getEvents();

    // Using mock data
    data.addAll([
      MockItem(title: "假資料1", id: 1, content: "這是第一個假資料的內容。"),
      MockItem(title: "假資料2", id: 2, content: "這是第二個假資料的內容。"),
      MockItem(title: "假資料3", id: 3, content: "這是第三個假資料的內容。"),
      MockItem(title: "假資料4", id: 4, content: "這是第四個假資料的內容。"),
      MockItem(title: "假資料5", id: 5, content: "這是第五個假資料的內容。"),
    ]);
  }
}
