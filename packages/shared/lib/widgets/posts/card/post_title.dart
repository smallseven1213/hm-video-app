import 'package:flutter/material.dart';




class PostTitleWidget extends StatelessWidget {
  final String title;
  final Color textColor;

  const PostTitleWidget({
    Key? key,
    required this.title,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(color: textColor),
    );
  }
}
