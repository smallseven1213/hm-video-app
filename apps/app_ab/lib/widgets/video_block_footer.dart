import 'package:app_ab/config/colors.dart';
import 'package:app_ab/widgets/channel_area_banner.dart';
import 'package:app_ab/widgets/glowing_icon.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/channel_info.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/navigator/delegate.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Widget? icon;
  final bool? animate;
  final Function onTap;
  final Color? buttonBgColor;
  final Color? buttonTextColor;

  const CustomButton({
    Key? key,
    required this.text,
    this.icon,
    this.animate = false,
    required this.onTap,
    this.buttonBgColor = const Color(0xffB5925C),
    this.buttonTextColor = Colors.white,
  }) : super(key: key);
  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward();
        });
        widget.onTap();
      },
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        decoration: BoxDecoration(
          color: widget.buttonBgColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: widget.animate == true ? _animation.value * 6.28 : 0,
                  child: widget.icon ??
                      Icon(Icons.refresh,
                          color: AppColors.colors[ColorKeys.buttonTextPrimary]),
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: TextStyle(
                color: widget.buttonTextColor,
                fontSize: 14,
              ),
            ),
          ],
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
            if (block.isCheckMore == true)
              Expanded(
                child: CustomButton(
                  text: '进入橱窗',
                  buttonBgColor: AppColors.colors[ColorKeys.buttonBgPrimary],
                  buttonTextColor:
                      AppColors.colors[ColorKeys.buttonTextPrimary],
                  icon: GlowingIcon(
                    color:
                        AppColors.colors[ColorKeys.buttonTextPrimary] as Color,
                    size: 20,
                    iconData: Icons.remove_red_eye_outlined,
                  ),
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
            if (block.isChange == true) ...[
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  text: '换一批',
                  animate: true,
                  buttonBgColor: AppColors.colors[ColorKeys.buttonBgCancel],
                  buttonTextColor: AppColors.colors[ColorKeys.buttonTextCancel],
                  icon: GlowingIcon(
                    color: AppColors.colors[ColorKeys.buttonTextCancel]!,
                    size: 20,
                    iconData: Icons.refresh,
                  ),
                  onTap: () {
                    updateBlock();
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
