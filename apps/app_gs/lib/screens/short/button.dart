// ExpanededButton, class Name "ShortBottomButton"
// has props(String title, String subscribe, activeIcon, unActiveIcon)

import 'package:flutter/material.dart';

class ShortButtonButton extends StatelessWidget {
  final String title;
  final String subscribe;
  final IconData activeIcon;
  final IconData unActiveIcon;
  final double? iconSize;
  final bool isLike;
  final Function()? onTap;

  const ShortButtonButton({
    Key? key,
    required this.title,
    required this.subscribe,
    required this.activeIcon,
    required this.unActiveIcon,
    this.iconSize,
      this.isLike = false,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  isLike ? activeIcon : unActiveIcon,
                size: iconSize ?? 24,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
        ));
  }
}
