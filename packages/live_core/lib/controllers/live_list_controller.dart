import 'dart:async';
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
  var isLoading = false.obs;
  var hasMore = true.obs;
  late StreamSubscription _messageSubscription; // 添加这个属性

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

  void setStatus(RoomStatus newStatus) => status.value = newStatus;
  void setSortType(SortType newSortType) => sortType.value = newSortType;
  void setChargeType(RoomChargeType newChargeType) =>
      chargeType.value = newChargeType;
  void setFollowType(FollowType newFollowType) =>
      followType.value = newFollowType;
  void setTagId(int? newTagId) => tagId.value = newTagId;

  fetchData({bool isLoadMore = false}) async {
    if (isLoading.value) return; // 防止同时触发多次加载
    isLoading.value = true;

    if (isLoadMore) {
      currentPage++;
    } else {
      currentPage = 1; // 如果是刷新或首次加载，重置页码为1
      hasMore.value = true; // 重置有更多数据的标志
    }
    if (hasMore.value) {
      try {
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

        hasMore.value = res.pagination.currentPage < res.pagination.total;
        filterRoomsByTagId();
      } finally {
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
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

  connectWs() {
    LiveSocketIOManager socketManager = LiveSocketIOManager();

    _messageSubscription = socketManager.messages.listen((message) {
      var decodedMessage = jsonDecode(message);
      handleWebSocketMessage(decodedMessage);
    });
  }

  void handleWebSocketMessage(Map<String, dynamic> decodedMessage) {
    String event = decodedMessage['event'];
    switch (event) {
      case 'broadcast:onAir':
        List<dynamic> dataList = decodedMessage['data']['list'];
        List<Room> newRooms =
            dataList.map<Room>((roomJson) => Room.fromJson(roomJson)).toList();
        roomsWithoutFilter.addAll(newRooms);
        filterRoomsByTagId();
        break;
      case 'broadcast:offAir':
        List<dynamic> dataList = decodedMessage['data']['list'];
        for (var data in dataList) {
          int idToRemove = data['id'];
          roomsWithoutFilter.removeWhere((room) => room.id == idToRemove);
          filterRoomsByTagId();
        }
        break;
      default:
        return;
    }
  }

  void reset() {
    tagId.value = null;
    status.value = RoomStatus.none;
    chargeType.value = RoomChargeType.none;
    sortType.value = SortType.defaultSort;
    followType.value = FollowType.none;

    // Cancel any ongoing timer for auto-refresh
    _messageSubscription.cancel();
  }
}
