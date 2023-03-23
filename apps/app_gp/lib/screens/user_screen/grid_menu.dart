import 'package:flutter/material.dart';

class GridMenuItem {
  final String name;
  final String icon;
  final Function onTap;

  GridMenuItem({
    required this.name,
    required this.icon,
    required this.onTap,
  });
}

class GridMenu extends StatelessWidget {
  GridMenu({Key? key}) : super(key: key);

  final menuItems = [
    GridMenuItem(
      name: '我的足迹',
      icon: 'assets/images/user_screen_footprint.png',
      onTap: () {},
    ),
    GridMenuItem(
      name: '我的喜欢',
      icon: 'assets/images/user_screen_like.png',
      onTap: () {},
    ),
    GridMenuItem(
      name: '我的收藏',
      icon: 'assets/images/user_screen_collection.png',
      onTap: () {},
    ),
    GridMenuItem(
      name: '推广分享',
      icon: 'assets/images/user_screen_share.png',
      onTap: () {},
    ),
    GridMenuItem(
      name: '在线客服',
      icon: 'assets/images/user_screen_online_service.png',
      onTap: () {},
    ),
    GridMenuItem(
      name: '应用中心',
      icon: 'assets/images/user_screen_app_center.png',
      onTap: () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var item = menuItems[index];
          return InkWell(
            onTap: item.onTap as void Function()?,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(item.icon),
                    width: 30,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.name,
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
        childCount: menuItems.length,
      ),
    );
  }
}
