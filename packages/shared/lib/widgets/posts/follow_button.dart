import 'package:flutter/material.dart';
import 'package:shared/models/index.dart';
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
    this.backgroundColor = const Color(0xff6874b6),
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserFavoritesSupplierConsumer(
      id: supplier.id ?? 0,
      info: supplier,
      actionType: 'follow',
      child: (isLiked, handleLike) => InkWell(
        onTap: handleLike,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: isLiked ? const Color(0xff464c61) : backgroundColor,
          ),
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                size: 18,
                isLiked ? Icons.check : Icons.add_rounded,
                color: isLiked ? const Color(0xffb2bac5) : textColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
