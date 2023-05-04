import 'package:app_gs/widgets/actor_avatar.dart';
import 'package:flutter/material.dart';

import 'short_card_info_tag.dart';

class ShortCardInfo extends StatelessWidget {
  final int index;
  const ShortCardInfo({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ActorAvatar(photoSid: '', width: 30, height: 30),
                const SizedBox(width: 6),
                Text('@演員名稱：${index + 1}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    )),
              ],
            ),
            const SizedBox(height: 8),
            const Text('網紅大集合',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                )),
            const SizedBox(height: 8),
            Row(
              children: const [
                ShortCardInfoTag(name: '#免費'),
                SizedBox(width: 8),
                ShortCardInfoTag(name: '#網紅'),
                SizedBox(width: 8),
                ShortCardInfoTag(name: '#大集合'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
