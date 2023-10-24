import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/navigator/delegate.dart';

import '../screens/layout_home_screen/channel_area_banner.dart';

enum ButtonType { primary, secondary }

class MyButton extends StatelessWidget {
  final String text;
  final ButtonType type;
  final Function onTap;

  const MyButton({
    Key? key,
    required this.text,
    required this.type,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (type) {
      case ButtonType.primary:
        backgroundColor = const Color(0xFFFE2C55);
        textColor = Colors.white;
        break;
      case ButtonType.secondary:
        backgroundColor = const Color(0xFFDEDEDE);
        textColor = const Color(0xFF50525A);
        break;
    }

    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 42,
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class VideoBlockFooter extends StatelessWidget {
  final Blocks block;
  final int channelId;
  final Function updateBlock;
  final double? imageRatio;
  final int film;

  const VideoBlockFooter(
      {Key? key,
      required this.block,
      required this.updateBlock,
      required this.channelId,
      this.imageRatio,
      required this.film})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // button Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (block.isChange == true)
              Expanded(
                child: MyButton(
                  text: '換一批',
                  type: ButtonType.secondary,
                  // icon: GlowingIcon(
                  //   color: AppColors.colors[ColorKeys.textPrimary]!,
                  //   size: 20,
                  //   iconData: Icons.refresh,
                  // ),
                  onTap: () {
                    updateBlock();
                  },
                ),
              ),
            if (block.isCheckMore == true) ...[
              const SizedBox(width: 8),
              Expanded(
                child: MyButton(
                  text: '進入櫥窗',
                  type: ButtonType.primary,
                  onTap: () {
                    if (film == 1) {
                      MyRouteDelegate.of(context).push(
                        AppRoutes.videoByBlock,
                        args: {
                          'blockId': block.id,
                          'title': block.name,
                          'channelId': channelId,
                        },
                      );
                    } else if (film == 2) {
                      MyRouteDelegate.of(context).push(
                        AppRoutes.videoByBlock,
                        args: {
                          'blockId': block.id,
                          'title': block.name,
                          'channelId': channelId,
                          'film': 2,
                        },
                      );
                    }
                    // updateBlock();
                  },
                ),
              ),
            ]
          ],
        ),
        if (block.banner != null)
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: ChannelAreaBanner(
              image: block.banner!,
            ),
          ),
      ],
    );
  }
}
