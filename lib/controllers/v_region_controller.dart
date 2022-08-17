import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/v_tab_collection.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/models/regions.dart';

class VRegionController extends GetxController implements VTabCollection {
  List<Region> regions = [];
  Region? current;

  Map<int, Region> getRegions() {
    return regions.asMap();
    // {
    //   0: Region(0, '推薦'),
    //   1: Region(1, '熱搜'),
    //   2: Region(2, '日韓精選'),
    //   3: Region(3, '綜藝集合'),
    //   4: Region(4, '英雄集結'),
    //   5: Region(5, '壞蛋集結'),
    // };
  }

  @override
  Map<int, VTabItem> getTabs() {
    return regions
        .map((value) => VTabItem(value.id, value.name,
            url: 'internal://region/${value.id}'))
        .toList()
        .asMap();
  }

  void setRegions(List<Region> _region) {
    regions = _region;
    update();
  }

  void setCurrentRegion(int idx) {
    current = regions[idx];
    update();
  }

  Region? getCurrentRegion() {
    return current;
  }
}
