import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/live_api.dart';
import '../models/room.dart';
import '../socket/live_web_socket_manager.dart';

final liveApi = LiveApi();

enum SortType {
  defaultSort,
  watch,
  income,
  newcomer,
  fans,
}

enum FollowType {
  none,
  followed,
}

final logger = Logger();

class LiveListController extends GetxController {
  var roomsWithoutFilter = <Room>[].obs;
  var rooms = <Room>[].obs;
  int currentPage = 1;
  final int perPage = 20;
  bool hasMore = true; // 是否還有更多資料

  Rx<int?> tagId = Rx<int?>(null);
  Rx<RoomStatus> status = Rx<RoomStatus>(RoomStatus.none);
  Rx<RoomChargeType> chargeType = Rx<RoomChargeType>(RoomChargeType.none);
  Rx<SortType> sortType = Rx<SortType>(SortType.defaultSort);
  Rx<FollowType> followType = Rx<FollowType>(FollowType.none);

  LiveListController() {
    ever(status, (_) => fetchData());
    ever(chargeType, (_) => fetchData());
    ever(sortType, (_) => fetchData());
    ever(followType, (_) => fetchData());
    ever(tagId, (_) => filterRoomsByTagId());

    fetchData();
  }

  @override
  void onInit() {
    super.onInit();
    LiveSocketIOManager socketManager = LiveSocketIOManager();

    socketManager.messages.listen((message) {
      var decodedMessage = jsonDecode(message);
      String event = decodedMessage['event'];

      if (event == 'broadcast:onAir') {
        print('###broadcast:onAir: $message');

        List<dynamic> dataList = decodedMessage['data']['list'];
        List<Room> newRooms =
            dataList.map<Room>((roomJson) => Room.fromJson(roomJson)).toList();
        roomsWithoutFilter.addAll(newRooms);
        // filterRoomsByTagId();
      } else if (event == 'broadcast:offAir') {
        print('###broadcast:offAir: $message');
        // 处理 'broadcast:offAir' 事件
        List<dynamic> dataList = decodedMessage['data']['list'];
        for (var data in dataList) {
          int idToRemove = data['id'];
          roomsWithoutFilter.removeWhere((room) => room.id == idToRemove);
        }
        // filterRoomsByTagId();
      } else {
        print('Received an unknown event: $event');
      }
    });
  }

  void setStatus(RoomStatus newStatus) => status.value = newStatus;
  void setSortType(SortType newSortType) => sortType.value = newSortType;
  void setChargeType(RoomChargeType newChargeType) =>
      chargeType.value = newChargeType;
  void setFollowType(FollowType newFollowType) =>
      followType.value = newFollowType;
  void setTagId(int? newTagId) => tagId.value = newTagId;

  fetchData({bool isLoadMore = false}) async {
    if (isLoadMore) {
      currentPage++;
    } else {
      currentPage = 1; // 如果是刷新或首次加载，重置页码为1
      hasMore = true; // 重置有更多数据的标志
    }
    if (hasMore) {
      var res = await liveApi.getRooms(
        page: currentPage,
        perPage: perPage,
        chargeType: chargeType.value.index,
        status: status.value.index,
        ranking: sortType.value,
        followType: followType.value.index,
      );

      if (isLoadMore) {
        roomsWithoutFilter.addAll(res.items);
      } else {
        roomsWithoutFilter.value = res.items;
      }

      hasMore = res.pagination.currentPage < res.pagination.total;
      filterRoomsByTagId();
    }
  }

  filterRoomsByTagId() {
    rooms.value = tagId.value == null
        ? roomsWithoutFilter
        : roomsWithoutFilter
            .where((room) =>
                room.tags.any((tag) => tag.id == tagId.value.toString()))
            .toList();
  }

  Room? getRoomById(int id) => rooms.firstWhereOrNull((room) => room.id == id);
  Room? getRoomByStreamerId(int streamerId) =>
      rooms.firstWhereOrNull((room) => room.streamerId == streamerId);

  void reset() {
    tagId.value = null;
    status.value = RoomStatus.none;
    chargeType.value = RoomChargeType.none;
    sortType.value = SortType.defaultSort;
    followType.value = FollowType.none;

    // Cancel any ongoing timer for auto-refresh
  }
}
