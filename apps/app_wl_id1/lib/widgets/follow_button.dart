import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final bool isLiked;

  const FollowButton({Key? key, required this.isLiked}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: isLiked ? const Color(0xfff1f1f2) : const Color(0xfffe2c55),
        borderRadius: BorderRadius.circular(4.0),
      ),
      alignment: Alignment.center,
      child: Text(
        isLiked ? '已關注' : '+ 關注',
        style: TextStyle(
          fontSize: 13,
          color: isLiked ? const Color(0xff161823) : Colors.white,
        ),
      ),
    );
  }
}
