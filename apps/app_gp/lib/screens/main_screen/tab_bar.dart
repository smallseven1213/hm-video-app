import 'package:flutter/material.dart';

class TabbarItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const TabbarItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
  });
}

class Tabbar extends StatefulWidget {
  // final List<TabbarItem> items;
  // final int activeIndex;
  // final void Function(int index) onChange;

  const Tabbar({
    Key? key,
  }) : super(key: key);

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  // mock tab items
  final List<TabbarItem> items = [
    TabbarItem(
      title: 'Home',
      icon: Icons.home,
      activeIcon: Icons.home,
    ),
    TabbarItem(
      title: 'Video',
      icon: Icons.video_library,
      activeIcon: Icons.video_library,
    ),
    TabbarItem(
      title: 'Profile',
      icon: Icons.person,
      activeIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: items
            .asMap()
            .map(
              (index, item) => MapEntry(
                index,
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // widget.onChange(index);
                    },
                    child: Container(
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.title,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }
}
