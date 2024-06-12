import 'package:flutter/material.dart';

import 'user_area.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SharedAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // padding left 20
            padding: const EdgeInsets.only(left: 12),
            height: 26,
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
          const UserArea()
        ],
      ),
    );
  }
}
