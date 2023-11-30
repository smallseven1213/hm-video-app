import 'package:flutter/material.dart';
import 'package:live_core/models/room.dart';
import 'package:shared/navigator/delegate.dart';

class RoomItem extends StatelessWidget {
  final Room room;

  const RoomItem({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        MyRouteDelegate.of(context).push(
          "/live_room",
          // args: {"pid": room.pid},
          args: {"pid": 247},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(6),
        child: Column(
          children: [
            // Expanded(
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(30),
            //     child: Image.network(
            //       room.cover,
            //       fit: BoxFit.cover,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 6),
            Text(
              room.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              room.nickname,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
