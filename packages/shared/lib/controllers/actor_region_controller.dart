import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/region.dart';

import '../apis/region_api.dart';

final RegionApi regionApi = RegionApi();
final logger = Logger();

class ActorRegionController extends GetxController {
  var regions = <Region>[].obs;

  ActorRegionController() {
    _fetchData();
  }

  _fetchData() async {
    var res = await regionApi.getActorRegions();
    regions.value = res;
  }
}
