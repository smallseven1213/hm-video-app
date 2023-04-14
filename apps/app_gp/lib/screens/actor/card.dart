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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: SidImage(
                      sid: photoSid, width: 80, height: 80, fit: BoxFit.cover),
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
            top: 0,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SidImage(
                sid: coverVertical ?? photoSid,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
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
                const Icon(Icons.arrow_forward_ios, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
