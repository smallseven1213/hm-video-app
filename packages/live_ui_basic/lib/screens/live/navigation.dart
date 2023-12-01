import 'package:flutter/material.dart';
import 'package:live_core/models/navigation.dart';
import 'package:live_core/widgets/navigation_provider.dart';
import 'package:get/get.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({Key? key}) : super(key: key);

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
} 

class _NavigationWidgetState extends State<NavigationWidget> {
  int _selectedIndex = 0; // 跟踪選中的索引

  @override
  Widget build(BuildContext context) {
    final Color activeColor = Colors.white;
    final Color inactiveColor = Color(0xFF898B99);

    return NavigationProvider(child: (List<Navigation> navigation) {
      if (navigation.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        height: 30,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: navigation.length,
          itemBuilder: (BuildContext context, int index) {
            Navigation nav = navigation[index];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index; // 更新選中的索引
                });
                // 實現導航邏輯
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10), // 文字間距為10px
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
