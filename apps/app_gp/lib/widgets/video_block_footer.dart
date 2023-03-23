import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared/models/channel_info.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Icon? icon;
  final bool? animate;

  const CustomButton({
    Key? key,
    required this.text,
    this.icon,
    this.animate = false,
  }) : super(key: key);
  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
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
    return InkWell(
      onTap: () {
        setState(() {
          _animationController.isCompleted
              ? _animationController.reverse()
              : _animationController.forward();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000916), Color(0xFF003F6C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          // opacity: 0.5,
          border: Border.all(color: Color(0xFF8594E2), width: 1),
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
                  child:
                      widget.icon ?? Icon(Icons.refresh, color: Colors.white),
                );
              },
            ),
            SizedBox(width: 8),
            Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
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
  final double? imageRatio;
  const VideoBlockFooter({
    Key? key,
    required this.block,
    this.imageRatio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('VideoBlockFooter build : ${block.toJson()}');
// isAreaAds
// isChange
// isCheckMore
    return Column(
      children: [
        // button Row
        // bottom Ad
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: CustomButton(
                    text: '進入櫥窗',
                    icon: Icon(Icons.refresh, color: Colors.white))),
            SizedBox(width: 8),
            Expanded(
                child: CustomButton(
                    text: '換一批',
                    animate: true,
                    icon: Icon(Icons.refresh, color: Colors.white))),
          ],
        )
      ],
    );
  }
}
