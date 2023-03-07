import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/channel_screen_tab_controller.dart';
import 'package:shared/controllers/layout_controller.dart';

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
  const Tabbar({
    Key? key,
  }) : super(key: key);

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  final ChannelScreenTabController channelScreenTabController =
      Get.find<ChannelScreenTabController>();
  final LayoutController layoutController =
      Get.find<LayoutController>(tag: 'layout1');

  void handleTapTabItem(int index) {
    channelScreenTabController.pageViewIndex.value = index;
  }

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
      child: Obx(
        () => Stack(
          children: [
            ListView(
              scrollDirection: Axis.horizontal,
              children: layoutController.layout
                  .asMap()
                  .map(
                    (index, item) => MapEntry(
                      index,
                      GestureDetector(
                        onTap: () {
                          handleTapTabItem(index);
                        },
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Obx(() => Text(
                                    item.name,
                                    style: TextStyle(
                                      color: channelScreenTabController
                                                  .tabIndex.value ==
                                              index
                                          ? Colors.blue
                                          : Colors.black,
                                      fontSize: 16,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
            Obx(
              () => Positioned(
                bottom: 0,
                left: channelScreenTabController.tabIndex.value * 100.0,
                child: Container(
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
