import 'package:flutter/material.dart';
import 'package:live_core/controllers/live_list_controller.dart';
import 'package:live_core/models/navigation.dart';
import 'package:live_core/widgets/navigation_provider.dart';
import 'package:get/get.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  NavigationWidgetState createState() => NavigationWidgetState();
}

class NavigationWidgetState extends State<NavigationWidget> {
  LiveListController liveListController = Get.find<LiveListController>();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Colors.white;
    const Color inactiveColor = Color(0xFF898B99);

    return NavigationProvider(child: (List<Navigation> navigation) {
      if (navigation.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: navigation.length,
          itemBuilder: (BuildContext context, int index) {
            Navigation nav = navigation[index];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                if (nav.rule == 'custom') {
                  liveListController.setTagId(null);
                } else {
                  liveListController.setTagId(nav.id);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                child: Text(
                  nav.name,
                  style: TextStyle(
                    color:
                        _selectedIndex == index ? activeColor : inactiveColor,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
