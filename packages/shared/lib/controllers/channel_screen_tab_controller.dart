// ChannelScreenTabController用來儲存目前tabIndex與pageViewIndex的狀態
// 並且在tabbar或pageView的index發生改變時，更新兩者的index

import 'package:get/get.dart';

import '../apis/vod_api.dart';
import '../models/block.dart';

class ChannelScreenTabController extends GetxController {
  var tabIndex = 0.obs;
  var pageViewIndex = 0.obs;
}
