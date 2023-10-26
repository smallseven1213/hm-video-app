import 'package:flutter/material.dart';
import '../actor_avatar.dart';

class HeaderFollowButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? handleLike;
  final String photoSid;

  const HeaderFollowButton({
    Key? key,
    required this.isLiked,
    required this.handleLike,
    required this.photoSid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: handleLike,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isLiked ? const Color(0xfff1f1f2) : const Color(0xfffff3f5),
        ),
        padding: const EdgeInsets.only(left: 3, top: 5, bottom: 5, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ActorAvatar(
              width: 21,
              height: 21,
              photoSid: photoSid,
            ),
            const SizedBox(width: 8),
            Text(
              isLiked ? '已關注' : '+ 關注',
              style: TextStyle(
                fontSize: 12,
                color:
                    isLiked ? const Color(0xff161823) : const Color(0xfffe2c55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
