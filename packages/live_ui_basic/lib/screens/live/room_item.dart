import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_core/apis/live_api.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/models/room.dart';
import 'package:live_core/widgets/live_image.dart';
import 'package:live_ui_basic/libs/showLiveDialog.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import 'countdown_timer.dart';

final liveApi = LiveApi();

class RoomItem extends StatelessWidget {
  final Room room;
  final LiveListController _controller = Get.find<LiveListController>();

  RoomItem({
    super.key,
    required this.room,
  });

  Widget _buildLabel({
    required Color color,
    required String text,
    Icon? icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: icon == null
          ? Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 9),
            )
          : RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(child: icon),
                  TextSpan(
                    text: text,
                    style: TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        bool updateRoomList = false;
        _controller.autoRefreshCancel();
        if (room.status == RoomStatus.ended.index) {
          showLiveDialog(
            context,
            title: '直播已結束',
            content: const Center(
              child: Text('直播已結束',
                  style: TextStyle(color: Colors.white, fontSize: 11)),
            ),
          );
          return;
        } else if (room.status == RoomStatus.notStarted.index) {
          updateRoomList = await MyRouteDelegate.of(context).push(
            AppRoutes.supplier,
            args: {'id': room.streamerId},
          );
        } else {
          updateRoomList = await MyRouteDelegate.of(context).push(
            "/live_room",
            args: {"pid": room.id},
          );
        }

        if (updateRoomList) {
          _controller.fetchData();
          _controller.startAutoRefresh();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.grey,
        ),
        // padding: const EdgeInsets.all(6),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: LiveImage(
                  key: ValueKey(room.playerCover ?? ''),
                  base64Url: room.playerCover ?? '',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                )),
            Positioned(
              left: 10,
              top: 10,
              child: Row(
                children: [
                  Image.asset(
                    "packages/live_ui_basic/assets/images/${room.userLive > 1000 ? 'ic_hot' : 'ic_view'}.webp",
                    width: 22,
                  ),
                  const SizedBox(width: 2),
                  Text('${room.userLive}'),
                ],
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: room.status == RoomStatus.live.index
                  ? _buildLabel(
                      color: room.chargeType == RoomChargeType.free.index
                          ? const Color(0xffe65fcf95)
                          : const Color(0xffe6845fcf),
                      text: room.chargeType == RoomChargeType.free.index
                          ? '免費'
                          : '付費',
                    )
                  : room.status == RoomStatus.ended.index
                      ? _buildLabel(
                          color: const Color(0xffe6cf795f),
                          text: '已結束',
                          icon: const Icon(Icons.access_time,
                              size: 12, color: Colors.white),
                        )
                      : CountdownTimer(
                          reserveAt: room.reserveAt ?? '',
                          chargeType: room.chargeType,
                        ),
            ),
            Positioned(
              left: 10,
              bottom: 30,
              child: Text(
                '@${room.nickname}',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: Text(
                room.tags.map((tag) => tag.name).join(', '),
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
