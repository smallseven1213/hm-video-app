import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/sid_image.dart';


class NextVideoWidget extends StatefulWidget {
  final Vod? video;

  const NextVideoWidget({super.key, this.video});

  @override
  _NextVideoWidgetState createState() => _NextVideoWidgetState();
}

class _NextVideoWidgetState extends State<NextVideoWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _heightAnimation =
        Tween<double>(begin: 48.0, end: 8.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Visibility(
          visible: _heightAnimation.value > 8.0,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              height: _heightAnimation.value,
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 7),
              child: child,
            ),
          ),
        );
      },
      child: widget.video == null
          ? const SizedBox.shrink()
          : _buildNotificationContent(),
    );
  }

  Widget _buildNotificationContent() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(22, 24, 35, 0.79),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SidImage(
                sid: widget.video!.coverVertical ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                widget.video!.title,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () async {
              await _animationController.forward();
              if (mounted) {
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
