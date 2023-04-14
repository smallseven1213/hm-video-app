import 'package:flutter/material.dart';
import 'package:shared/widgets/sid_image.dart';

class ActorCard extends StatelessWidget {
  final int id;
  final String name;
  final String photoSid;
  final String description;
  final String actorCollectTimes;
  final String? coverVertical;
  const ActorCard({
    Key? key,
    required this.id,
    required this.name,
    required this.photoSid,
    required this.description,
    required this.actorCollectTimes,
    this.coverVertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Stack(
        children: [
          if (coverVertical != '' && coverVertical != null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SidImage(
                  key: ValueKey(coverVertical),
                  sid: coverVertical ?? photoSid,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (coverVertical == '' || coverVertical == null)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.5], // 控制顏色分佈的位置
                    colors: [
                      Color(0xFF00091A), // 左上角顏色
                      Color(0xFFFF4545), // 位於中間位置的顏色
                    ],
                  ),
                ),
                // 您可以在這裡添加其他屬性，例如寬度、高度或子組件
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: SidImage(
                      key: ValueKey(photoSid),
                      sid: photoSid,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '女優簡介',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                Text(
                  actorCollectTimes,
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(width: 6),
                const Icon(
                  Icons.favorite_outline,
                  size: 12,
                  color: Color(0xFF21AFFF),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
