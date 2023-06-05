import 'package:app_gs/widgets/button.dart';
import 'package:app_gs/widgets/glowing_icon.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'enums.dart';

final logger = Logger();

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final String text;
  final VoidCallback onPressed;
  final LikeButtonType? type;

  const LikeButton({
    Key? key,
    required this.isLiked,
    required this.onPressed,
    required this.text,
    this.type,
  }) : super(key: key);

  @override
  LikeButtonState createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> {
  LikeButtonType type = LikeButtonType.favorite;

  @override
  void initState() {
    super.initState();
    type = widget.type ?? LikeButtonType.favorite;
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData = widget.isLiked ? Icons.favorite : Icons.favorite_border;
    if (type == LikeButtonType.bookmark) {
      iconData = widget.isLiked ? Icons.bookmark : Icons.bookmark_border;
    }
    return Button(
      text: widget.text,
      type: widget.isLiked ? 'secondary' : 'primary',
      onPressed: () {
        widget.onPressed();
      },
      icon: Icon(
        iconData,
        color: widget.isLiked ? Colors.yellow.shade700 : Colors.white,
        size: 20,
      ),
    );
  }
}
