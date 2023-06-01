import 'package:app_gs/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/utils/video_info_formatter.dart';

class ShortButtonButton extends StatefulWidget {
  final String subscribe;
  final IconData icon;
  final double? iconSize;
  final bool isLike;
  final int? count;
  final Function()? onTap;

  const ShortButtonButton(
      {Key? key,
      required this.subscribe,
      required this.icon,
      this.count = 0,
      this.iconSize,
      this.isLike = false,
      this.onTap = _defaultOnTap})
      : super(key: key);

  static void _defaultOnTap() {}

  @override
  ShortButtonButtonState createState() => ShortButtonButtonState();
}

class ShortButtonButtonState extends State<ShortButtonButton> {
  late int selfCount;

  @override
  void initState() {
    super.initState();
    selfCount = widget.count ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            widget.onTap?.call();
            setState(() {
              selfCount = widget.isLike ? selfCount - 1 : selfCount + 1;
            });
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  widget.icon,
                  size: widget.iconSize ?? 24,
                  color: widget.isLike
                      ? AppColors.colors[ColorKeys.primary]
                      : Colors.white,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getViewTimes(selfCount, shouldCalculateThousands: false),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.subscribe,
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
