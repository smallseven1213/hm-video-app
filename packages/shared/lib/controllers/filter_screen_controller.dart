// FilterScreenController is a getx controller

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/vod_api.dart';
import '../models/block_vod.dart';
import '../models/vod.dart';

final logger = Logger();
final vodApi = VodApi();

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
        {'name': '全部', 'value': null},
        // 這裡使用 API 請求填充其他選項
      ],
    },
    {
      'key': 'publisherId',
      'options': [
        {'name': '全部', 'value': null},
        // 這裡使用 API 請求填充其他選項
      ],
    },
    {
      'key': 'chargeType',
      'options': [
        {'name': '全部', 'value': null},
        {'name': '免費', 'value': 1},
        {'name': '金幣', 'value': 2},
        {'name': 'VIP', 'value': 3}
      ],
    },
    {
      'key': 'film',
      'options': [
        {'name': '長視頻', 'value': 1},
        {'name': '短視頻', 'value': 2},
        {'name': '漫畫', 'value': 3}
      ],
    },
  ].obs;

  final Map<String, Set<dynamic>> selectedOptions = {
    'order': {1},
    'regionId': {null},
    'publisherId': {null},
    'chargeType': {null},
    'film': {1}
  }.obs;

  final List<Vod> filterResults = <Vod>[].obs;

  int _page = 1;
  bool _isLoading = false;
  RxBool hasMoreData = true.obs;

  void handleOptionChange(String key, dynamic value) {
    if (key == 'order') {
      // 如果選擇了 "order" 中的任何一個選項，則清除所有其他選項並選擇當前選項
      selectedOptions[key]!.clear();
      selectedOptions[key]!.add(value);
    } else if (value == null) {
      // 如果選擇了 "全部"，則清除所有其他選項
      selectedOptions[key]!.clear();
      selectedOptions[key]!.add(null);
    } else {
      // 如果選擇了其他選項，則取消選擇 "全部" 選項
      selectedOptions[key]!.remove(null);
      if (selectedOptions[key]!.contains(value)) {
        selectedOptions[key]!.remove(value);
      } else {
        selectedOptions[key]!.add(value);
      }
    }
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
      if (values.isNotEmpty && values.first != null) {
        String valueString = values.map((value) => value.toString()).join(',');
        queryItems.add('$key=$valueString');
      }
    });

    String queryString = queryItems.join('&');
    logger.i(queryString);

    var res = await vodApi.getSimpleManyBy(
        page: page ?? _page, limit: 100, queryString: queryString);

    if (res.vods.isNotEmpty) {
      if (refresh == true) {
        filterResults.clear();
      }
      filterResults.addAll(res.vods);
    } else {
      hasMoreData.value = false;
    }
    _isLoading = false;
  }

  @override
  void onInit() {
    super.onInit();
    _handleSelectedOptionsChange();
  }
}
