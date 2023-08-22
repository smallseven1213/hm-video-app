import 'package:app_51ss/config/colors.dart';
import 'package:app_51ss/widgets/channel_area_banner.dart';
import 'package:app_51ss/widgets/glowing_icon.dart';
import 'package:flutter/foundation.dart';
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

  const CustomButton({
    Key? key,
    required this.text,
    this.icon,
    this.animate = false,
    required this.onTap,
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
          gradient: kIsWeb
              ? null
              : const LinearGradient(
                  colors: [Color(0xFF000916), Color(0xFF003F6C)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          // opacity: 0.5,
          border: Border.all(color: const Color(0xFF8594E2), width: 1),
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
                      const Icon(Icons.refresh, color: Colors.white),
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
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
                  text: '進入櫥窗',
                  icon: GlowingIcon(
                    color: AppColors.colors[ColorKeys.textPrimary]!,
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
                  text: '換一批',
                  animate: true,
                  icon: GlowingIcon(
                    color: AppColors.colors[ColorKeys.textPrimary]!,
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
