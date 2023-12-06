import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/command.dart';

class CommandsController extends GetxController {
  final liveApi = LiveApi();
  Rx<List<Command>> commands = Rx<List<Command>>([]);

  @override
  void onInit() {
    super.onInit();
    fetchGifts();
  }

  void fetchGifts() async {
    try {
      var response = await liveApi.getCommands();
      commands.value = response.data;
    } catch (e) {
      print(e);
    }
  }
}
