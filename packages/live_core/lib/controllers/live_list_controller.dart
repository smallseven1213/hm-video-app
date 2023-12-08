import 'package:get/get.dart';

import '../apis/live_api.dart';
import '../models/live_api_response_base.dart';
import '../models/room.dart';

final liveApi = LiveApi();

enum LiveListSortType {
  defaultSort,
  userLive,
  userCost,
  hostEnter,
}

class LiveListController extends GetxController {
  var rooms = <Room>[].obs; // 用于存储从API获取的所有房间数据
  var filteredRooms = <Room>[].obs;
  var roomsWithoutSort = <Room>[].obs;

  var _tagId = Rxn<int>();
  var chargeType = RoomChargeType.none.obs;
  var status = RoomStatus.none.obs;
  var sortType = LiveListSortType.defaultSort.obs; // 使用 .obs 使其成为可观察的

  // init
  @override
  void onInit() {
    super.onInit();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      LiveApiResponseBase<List<Room>> res = await liveApi.getRooms();
      rooms.value = res.data;

    } catch (e) {
      print(e);
    }
  }

  // get room by id
  Room? getRoomById(int id) {
    return rooms.firstWhere((room) => room.pid == id);
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
}
