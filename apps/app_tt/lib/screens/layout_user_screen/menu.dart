import 'package:flutter/material.dart';

import 'menu_item.dart';

class UserMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      color: Colors.white,
      child: ListView(
        children: [
          MenuItem(
            icon: Icons.home,
            text: 'Home',
            onTap: () => print('Home tapped'),
          ),
          MenuItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () => print('Settings tapped'),
          ),
          // Add more menu items here
        ],
      ),
    );
  }
}
