import 'package:flutter/material.dart';

import 'user_area.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final int coins;

  const SharedAppBar({super.key, this.isLoggedIn = false, this.coins = 0});

  @override
  Size get preferredSize => Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: 80,
            child: const Image(
              image: AssetImage('assets/images/asia_bet.png'),
              fit: BoxFit.contain,
              height: 35,
            ),
            // child: Image.asset(
            //   'assets/images/asia_bet.png',
            //   fit: BoxFit.contain,
            // ),
          ),
          // Spacer(),
          UserArea()
        ],
      ),
    );
  }
}
