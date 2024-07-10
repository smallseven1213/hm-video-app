import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
import 'package:shared/modules/post/post_consumer.dart';
import 'package:shared/modules/user/user_favorites_supplier_consumer.dart';

class FollowButton extends StatelessWidget {
  final bool? isDarkMode;
  final Supplier supplier;
  final Color? backgroundColor;
  final Color? textColor;

  const FollowButton({
    Key? key,
    required this.supplier,
    this.isDarkMode = true,
    this.backgroundColor = const Color(0xfffe2c55),
    this.textColor = const Color(0xff161823),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserFavoritesSupplierConsumer(
      id: supplier.id ?? 0,
      info: supplier,
      actionType: 'follow',
      child: (isLiked, handleLike) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: HeaderFollowButton(
          isLiked: isLiked,
          handleLike: handleLike,
          photoSid: post['supplier'].photoSid ?? '',
          backgroundColor: backgroundColor,
          textColor: textColor,
        ),
      ),
    );
  }
}

class HeaderFollowButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? handleLike;
  final String photoSid;
  final Color? backgroundColor;
  final Color? textColor;

  const HeaderFollowButton({
    Key? key,
    required this.isLiked,
    required this.handleLike,
    required this.photoSid,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: handleLike,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isLiked ? Colors.grey : backgroundColor,
        ),
        padding: const EdgeInsets.only(left: 3, top: 5, bottom: 5, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Text(
              isLiked ? '已關注' : '+ 關注',
              style: TextStyle(
                fontSize: 12,
                color: isLiked ? Colors.white : textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
