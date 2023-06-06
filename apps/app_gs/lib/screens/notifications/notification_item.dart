import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class NotificationItem extends StatefulWidget {
  final String title;
  final String content;

  const NotificationItem({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _arrowAnimation = Tween(begin: 0.0, end: pi).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // title
        ListTile(
          contentPadding: const EdgeInsets.only(left: 8.0, right: 0),
          leading: AnimatedBuilder(
            animation: _arrowAnimation,
            builder: (_, child) {
              return Transform.rotate(
                angle: _arrowAnimation.value,
                child: child,
              );
            },
            child: const Icon(
              Icons.expand_more,
              color: Colors.white,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const Text(
                '2022-2-2',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (_isExpanded) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
        ),
        // content
        Visibility(
          visible: _isExpanded,
          child: Column(
            children: [
              Container(
                height: 1,
                color: const Color(0xFF7AA2C8).withOpacity(0.3),
              ),
              ListTile(
                contentPadding: const EdgeInsets.all(0),
                title: HtmlWidget(
                  widget.content,
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
