import 'package:flutter/material.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/short/button.dart';
import '../widgets/shortcard/index.dart';

class ShortPage extends StatefulWidget {
  final int itemCount;

  const ShortPage({Key? key, required this.itemCount}) : super(key: key);

  @override
  ShortPageState createState() => ShortPageState();
}

class ShortPageState extends State<ShortPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.itemCount,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ShortCard(index: index),
                  Container(
                    height: 90,
                    // gradient background
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Color(0xFF002869),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        ShortButtomButton(
                          title: '1.9萬',
                          subscribe: '喜歡就點讚',
                          activeIcon: Icons.favorite,
                          unActiveIcon: Icons.favorite_border,
                        ),
                        ShortButtomButton(
                          title: '1.9萬',
                          subscribe: '添加到收藏',
                          // icon is star
                          activeIcon: Icons.star,
                          unActiveIcon: Icons.star_border,
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
            scrollDirection: Axis.vertical,
          ),
          const FloatPageBackButton()
        ],
      ),
    );
  }
}
