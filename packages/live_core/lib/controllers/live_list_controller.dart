import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_api_response_base.dart';
import '../models/room.dart';
import '../models/streamer.dart';

final liveApi = LiveApi();

enum LiveListSortType {
  defaultSort,
  userLive,
  userCost,
  hostEnter,
}

enum FollowType {
  none,
  followed,
}

class LiveListController extends GetxController {
  var rooms = <Room>[].obs; // 用于存储从API获取的所有房间数据
  var filteredRooms = <Room>[].obs;
  var roomsWithoutSort = <Room>[].obs;

  final _tagId = Rxn<int>();
  var status = RoomStatus.none.obs;
  var chargeType = RoomChargeType.none.obs;
  var sortType = LiveListSortType.defaultSort.obs; // 使用 .obs 使其成为可观察的
  var followType = FollowType.none.obs;

  // init
  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      List<Room> res = await liveApi.getRooms();
      rooms.value = res;
      filteredRooms.value = res;
      roomsWithoutSort.value = res;
    } catch (e) {
      print(e);
    }
  }

  // get room by id
  Room? getRoomById(int id) {
    if (rooms.value.isEmpty) {
      return null;
    }
    return rooms.value.firstWhere((room) => room.id == id);
  }

  void filter({
    int? tagId,
    RoomChargeType? roomChargeType,
    RoomStatus? roomStatus,
  }) {
    _tagId.value = tagId;
    chargeType.value = roomChargeType ?? chargeType.value;
    status.value = roomStatus ?? status.value;
    var filtered = rooms.where((room) {
      bool isTagIdMatch = _tagId.value == null ||
          room.tags.any((tag) => tag.id == _tagId.value.toString());
      bool isChargeTypeMatch = chargeType.value == RoomChargeType.none ||
          room.chargeType == chargeType.value.index;
      bool isStatusMatch = status.value == RoomStatus.none ||
          (room.status == status.value.index);

      return isTagIdMatch && isChargeTypeMatch && isStatusMatch;
    }).toList();
    filteredRooms.value = filtered;
    roomsWithoutSort.value = filtered;
  }

  void sort({
    LiveListSortType? liveListSortType,
  }) {
    sortType.value = liveListSortType ?? sortType.value;

    switch (sortType.value) {
      case LiveListSortType.userLive:
        filteredRooms.sort((a, b) => b.userLive.compareTo(a.userLive));
        break;
      case LiveListSortType.userCost:
        filteredRooms.sort((a, b) => b.userCost.compareTo(a.userCost));
        break;
      case LiveListSortType.hostEnter:
        filteredRooms.sort((a, b) =>
            DateTime.parse(b.hostEnter).compareTo(DateTime.parse(a.hostEnter)));
        break;
      case LiveListSortType.defaultSort:
        filteredRooms.value = List.from(roomsWithoutSort);
        break;
      default:
        break;
    }

    update();
  }

  void filterVideosByFollowedStreamers({
    FollowType? filterFollowType,
    List<Streamer>? follows,
  }) {
    // 创建包含 follows 列表中所有主播ID的集合
    followType.value = filterFollowType ?? followType.value;

    if (follows == null) {
      filteredRooms.value = rooms;
    } else {
      Set<int> followedStreamerIds =
          follows.map((streamer) => streamer.id).toSet();
      // 过滤出 videoList 中主播ID存在于 followedStreamerIds 的视频
      filteredRooms.value = filteredRooms
          .where((video) => followedStreamerIds.contains(video.streamerId))
          .toList();
    }
  }

  // get room by streamer id
  Room? getRoomByStreamerId(int streamerId) {
    for (var room in rooms.value) {
      if (room.streamerId == streamerId) {
        return room;
      }
    }

    return null;
  }
}
