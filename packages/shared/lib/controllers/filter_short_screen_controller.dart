import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/region_api.dart';
import '../apis/supplier_api.dart';
import '../apis/vod_api.dart';

final logger = Logger();
final vodApi = VodApi();
final regionApi = RegionApi();
final supplierApi = SupplierApi();

const limit = 20;

class FilterShortScreenController extends GetxController {
  final film = 2;
  final RxList<Map<String, dynamic>> menuData = [
    {
      'key': 'order',
      'options': [
        {'name': '最新', 'value': 1},
        {'name': '最熱', 'value': 2}
      ],
    },
    {
      'key': 'regionId',
      'options': [
        {'name': '全部地區', 'value': 0},
        // 這裡使用 API 請求填充其他選項
      ],
    },
    {
      'key': 'supplierId',
      'options': [
        {'name': '全部UP主', 'value': 0},
        // 這裡使用 API 請求填充其他選項
      ],
    },
    {
      'key': 'chargeType',
      'options': [
        {'name': '全部付費類型', 'value': 0},
        {'name': '免費', 'value': 1},
        {'name': '金幣', 'value': 2},
        {'name': 'VIP', 'value': 3}
      ],
    },
    // {
    //   'key': 'film',
    //   'options': [
    //     {'name': '長視頻', 'value': 1},
    //     {'name': '短視頻', 'value': 2},
    //     {'name': '漫畫', 'value': 3}
    //   ],
    // },
  ].obs;

  final RxMap<String, Set<dynamic>> selectedOptions = {
    'order': {1}.obs,
    'regionId': {0}.obs,
    'supplierId': {0}.obs,
    'chargeType': {0}.obs,
    // 'film': {1}.obs,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    logger.i('FILTER SCREEN INITIAL====================');
    _handleInitRegionData();
    _handleInitSuppliersData();

    Get.find<AuthController>().token.listen((event) {
      _handleInitRegionData();
      _handleInitSuppliersData();
    });
  }

  void _handleInitRegionData() async {
    var res = await regionApi.getRegions(film);
    var regionData =
        res.map((item) => {'name': item.name, 'value': item.id}).toList();

    int indexToUpdate = 1;
    menuData[indexToUpdate].update('options', (existingOptions) {
      return [...existingOptions, ...regionData];
    });
    menuData.refresh();
  }

  void _handleInitSuppliersData() async {
    try {
      var res =
          await supplierApi.getManyBy(isRecommend: true, sortBy: 1, name: '');
      var suppliersData =
          res.map((item) => {'name': item.name, 'value': item.id}).toList();

      int indexToUpdate = 2;
      menuData[indexToUpdate].update('options', (existingOptions) {
        return [...existingOptions, ...suppliersData];
      });
      // print()
      menuData.refresh();
    } catch (e) {
      print('@@@error: $e');
    }
  }

  void handleOptionChange(String key, dynamic value) {
    if (key == 'order' ||
        key == 'chargeType' ||
        key == 'regionId' ||
        key == 'supplierId') {
      // 如果選擇了 "order" 中的任何一個選項，則清除所有其他選項並選擇當前選項
      selectedOptions[key]!.clear();
      selectedOptions[key]!.add(value);
    } else if (value == 0) {
      // 如果選擇了 "全部"，則清除所有其他選項
      selectedOptions[key]!.clear();
      selectedOptions[key]!.add(0);
    } else {
      // 如果選擇了其他選項，則取消選擇 "全部" 選項
      selectedOptions[key]!.remove(0);
      if (selectedOptions[key]!.contains(value)) {
        selectedOptions[key]!.remove(value);
      } else {
        selectedOptions[key]!.add(value);
      }
    }
    selectedOptions.refresh();
  }
}
