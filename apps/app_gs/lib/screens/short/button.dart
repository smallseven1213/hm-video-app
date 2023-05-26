// ExpanededButton, class Name "ShortBottomButton"
// has props(String title, String subscribe, activeIcon, unActiveIcon)

import 'package:app_gs/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';

class ShortButtonButton extends StatelessWidget {
  final String title;
  final String subscribe;
  final IconData icon;
  final double? iconSize;
  final bool isLike;
  final Function()? onTap;

  const ShortButtonButton(
      {Key? key,
      required this.title,
      required this.subscribe,
      required this.icon,
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
                  icon,
                  size: iconSize ?? 24,
                  color: isLike
                      ? AppColors.colors[ColorKeys.primary]
                      : Colors.white,
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
