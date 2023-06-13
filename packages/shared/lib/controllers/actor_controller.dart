import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/actor_api.dart';
import '../models/actor.dart';

final ActorApi actorApi = ActorApi();
final logger = Logger();

class ActorController extends GetxController {
  var actor = Actor.fromJson({}).obs;
  int actorId;

  ActorController({required this.actorId}) {
    _fetchData();
    Get.find<AuthController>().token.listen((event) {
      _fetchData();
    });
  }

  _fetchData() async {
    var res = await actorApi.getOne(actorId);
    actor.value = res;
  }

  void incrementActorCollectTimes() {
    var currentValue = actor.value.actorCollectTimes ?? 0;
    actor.value.actorCollectTimes = currentValue + 1;
    actor.refresh();
  }

  void decrementActorCollectTimes() {
    var currentValue = actor.value.actorCollectTimes ?? 0;
    if (currentValue > 0) {
      actor.value.actorCollectTimes = currentValue - 1;
      actor.refresh();
    }
  }
}
