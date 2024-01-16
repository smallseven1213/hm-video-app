import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../apis/live_api.dart';
import '../models/room.dart';
import '../models/streamer.dart';

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
  Timer? _timer;
  var roomsWithoutFilter = <Room>[].obs;
  var rooms = <Room>[].obs;

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

  fetchData() async {
    var res = await liveApi.getRooms(
      chargeType: chargeType.value.index,
      status: status.value.index,
      ranking: sortType.value,
    );
    roomsWithoutFilter.value = res;
    filterRoomsByTagId();
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

  void filterVideosByFollowedStreamers({
    FollowType? filterFollowType,
    List<Streamer>? follows,
  }) {
    followType.value = filterFollowType ?? followType.value;
    if (follows != null) {
      Set<int> followedStreamerIds =
          follows.map((streamer) => streamer.id).toSet();
      rooms.value = rooms
          .where((video) => followedStreamerIds.contains(video.streamerId))
          .toList();
    }
  }

  void startAutoRefresh() {
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      fetchData();
    });
  }

  void autoRefreshCancel() {
    _timer?.cancel();
  }
}
