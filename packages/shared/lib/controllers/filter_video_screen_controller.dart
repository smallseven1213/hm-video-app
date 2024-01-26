import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/auth_controller.dart';

import '../apis/publisher_api.dart';
import '../apis/region_api.dart';
import '../apis/vod_api.dart';

final logger = Logger();
final vodApi = VodApi();
final regionApi = RegionApi();
final publisherApi = PublisherApi();

const limit = 20;

class FilterVideoScreenController extends GetxController {
  final RxList<Map<String, dynamic>> menuData = [
    {
      'key': 'order',
      'options': [
        {'name': '最新', 'value': 1, 'i18nKey': 'latest'},
        {'name': '最熱', 'value': 2, 'i18nKey': 'hottest'},
      ],
    },
    {
      'key': 'regionId',
      'options': [
        {'name': '全部地區', 'value': 0, 'i18nKey': 'all_regions'},
        // 這裡使用 API 請求填充其他選項
      ],
    },
    {
      'key': 'publisherId',
      'options': [
        {'name': '全部廠商', 'value': 0, 'i18nKey': 'all_publisher'},
        // 這裡使用 API 請求填充其他選項
      ],
    },
    {
      'key': 'chargeType',
      'options': [
        {'name': '全部付費類型', 'value': 0, 'i18nKey': 'all_charge_type'},
        {'name': '免費', 'value': 1, 'i18nKey': 'free'},
        {'name': '金幣', 'value': 2, 'i18nKey': 'coin'},
        {'name': 'VIP', 'value': 3, 'i18nKey': 'vip'}
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
    'publisherId': {0}.obs,
    'chargeType': {0}.obs,
    // 'film': {1}.obs,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    logger.i('FILTER SCREEN INITIAL====================');
    _handleInitRegionData();
    _handleInitPublisherRecommendData();

    Get.find<AuthController>().token.listen((event) {
      _handleInitRegionData();
      _handleInitPublisherRecommendData();
    });
  }

  String findName(String key, int value) {
    // find name from menuData by key and value, return name
    var options = menuData.firstWhere((item) => item['key'] == key)['options'];
    var name = options.firstWhere((item) => item['value'] == value)['name'];
    return name;
  }

  void _handleInitRegionData() async {
    var res = await regionApi.getRegions(1);
    var regionData =
        res.map((item) => {'name': item.name, 'value': item.id}).toList();

    int indexToUpdate = 1;
    menuData[indexToUpdate].update('options', (existingOptions) {
      return [...existingOptions, ...regionData];
    });
    menuData.refresh();
  }

  void _handleInitPublisherRecommendData() async {
    var res = await publisherApi.getRecommend();
    var publisherData =
        res.map((item) => {'name': item.name, 'value': item.id}).toList();

    int indexToUpdate = 2;
    menuData[indexToUpdate].update('options', (existingOptions) {
      return [...existingOptions, ...publisherData];
    });
    menuData.refresh();
  }

  void handleOptionChange(String key, dynamic value) {
    if (key == 'order' ||
        key == 'chargeType' ||
        key == 'regionId' ||
        key == 'publisherId') {
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
