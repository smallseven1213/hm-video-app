import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/utils/video_info_formatter.dart';

final logger = Logger();

class ShortMenuButton extends StatelessWidget {
  final String subscribe;
  final IconData icon;
  final double? iconSize;
  final bool isLike;
  final int? count;
  final bool? displayFavoriteAndCollectCount;
  final Function()? onTap;

  const ShortMenuButton(
      {Key? key,
      required this.subscribe,
      required this.icon,
      this.count = 0,
      this.iconSize,
      this.displayFavoriteAndCollectCount = true,
      this.isLike = false,
      this.onTap = _defaultOnTap})
      : super(key: key);

  static void _defaultOnTap() {}

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize ?? 24,
              color: isLike ? const Color(0xffFFC700) : Colors.white,
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (displayFavoriteAndCollectCount == true)
                  Text(
                    formatNumberToUnit(count ?? 0,
                        shouldCalculateThousands: false),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                Text(
                  subscribe,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
