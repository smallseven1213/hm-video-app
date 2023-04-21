import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/publisher_api.dart';
import '../apis/region_api.dart';
import '../apis/vod_api.dart';
import '../models/vod.dart';

final logger = Logger();
final vodApi = VodApi();
final regionApi = RegionApi();
final publisherApi = PublisherApi();

class FilterScreenController extends GetxController {
  final List<Map<String, dynamic>> menuData = [
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
      'key': 'publisherId',
      'options': [
        {'name': '全部廠商', 'value': 0},
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
    'publisherId': {0}.obs,
    'chargeType': {0}.obs,
    // 'film': {1}.obs,
  }.obs;

  final List<Vod> filterResults = <Vod>[].obs;

  int _page = 1;
  bool _isLoading = false;
  RxBool hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    _handleInitRegionData();
    _handleInitPublisherRecommendData();
    _handleSelectedOptionsChange();
  }

  String findName(String key, int value) {
    // find name from menuData by key and value, return name
    var options = menuData.firstWhere((item) => item['key'] == key)['options'];
    var name = options.firstWhere((item) => item['value'] == value)['name'];
    return name;
  }

  void _handleInitRegionData() async {
    var res = await regionApi.getRegions();
    var regionData =
        res.map((item) => {'name': item.name, 'value': item.id}).toList();

    var newOptions = [...menuData[1]['options'], ...regionData];
    int indexToUpdate = 1;
    menuData.removeAt(indexToUpdate);
    menuData.insert(
        indexToUpdate,
        {
          'key': 'regionId',
          'options': newOptions,
        } as Map<String, dynamic>);
  }

  void _handleInitPublisherRecommendData() async {
    var res = await publisherApi.getRecommend();
    var publisherData =
        res.map((item) => {'name': item.name, 'value': item.id}).toList();

    var newOptions = [...menuData[2]['options'], ...publisherData];
    int indexToUpdate = 2;
    menuData.removeAt(indexToUpdate);
    menuData.insert(
        indexToUpdate,
        {
          'key': 'publisherId',
          'options': newOptions,
        } as Map<String, dynamic>);
  }

  void handleOptionChange(String key, dynamic value) {
    if (key == 'order' || key == 'chargeType') {
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
    _page = 1;
    _handleSelectedOptionsChange(refresh: true);
  }

  void loadNextPage() async {
    _page += 1;
    _handleSelectedOptionsChange(); // 修改此方法以接受 page 參數
  }

  Future<void> _handleSelectedOptionsChange({int? page, bool? refresh}) async {
    _isLoading = true;
    List<String> queryItems = [];

    selectedOptions.forEach((key, values) {
      if (values.isNotEmpty && values.first != 0) {
        String valueString = values.map((value) => value.toString()).join(',');
        queryItems.add('$key=$valueString');
      }
    });

    String queryString = queryItems.join('&');
    logger.i(queryString);

    var res = await vodApi.getSimpleManyBy(
        page: page ?? _page, limit: 20, queryString: queryString);

    if (refresh == true) {
      filterResults.clear();
      filterResults.addAll(res.vods);
    } else {
      if (res.vods.isNotEmpty) {
        filterResults.addAll(res.vods);
      } else {
        hasMoreData.value = false;
      }
    }

    _isLoading = false;
  }
}
