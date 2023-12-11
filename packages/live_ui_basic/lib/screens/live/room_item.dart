import 'package:flutter/material.dart';
import 'package:live_core/models/room.dart';
import 'package:shared/navigator/delegate.dart';
import 'package:shared/utils/datetime_formatter.dart';

import '../../widgets/network_image.dart';

class RoomItem extends StatelessWidget {
  final Room room;

  const RoomItem({super.key, required this.room});

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
      onTap: () {
        MyRouteDelegate.of(context).push(
          "/live_room",
          args: {"pid": room.pid},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(6),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: NetworkImageWidget(url: room.playerCover ?? ''),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: Row(
                children: [
                  // 測東西用
                  Text('${room.pid}'),
                  Icon(
                    room.userLive > 1000
                        ? Icons.local_fire_department
                        : Icons.remove_red_eye,
                  ),
                  const SizedBox(width: 4),
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
                    : _buildLabel(
                        color: const Color(0xffe6cf795f),
                        text: room.status == RoomStatus.ended.index
                            ? '已結束'
                            : formatDateTime(room.reserveAt ?? ''),
                        icon: Icon(Icons.access_time,
                            size: 12, color: Colors.white),
                      )),
            Positioned(
              left: 10,
              bottom: 30,
              child: Text(
                '@${room.nickname}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: Text(
                room.tags.map((tag) => tag.name).join(', '),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
