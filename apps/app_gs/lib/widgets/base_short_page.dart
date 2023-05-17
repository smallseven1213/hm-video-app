import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/short/button.dart';
import 'shortcard/index.dart';

class BaseShortPage extends StatefulWidget {
  final Function() createController;
  final int videoId;
  final int itemId; // areaId, tagId, supplierId

  const BaseShortPage(
      {required this.createController,
      required this.videoId,
      required this.itemId,
      Key? key})
      : super(key: key);

  @override
  BaseShortPageState createState() => BaseShortPageState();
}

class BaseShortPageState extends State<BaseShortPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final controller = widget.createController();

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return PageView.builder(
              controller: _pageController,
              itemCount: controller.data.length,
              onPageChanged: (int index) {
                setState(() {
                  currentPage = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Expanded(
                        child: ShortCard(
                            isActive: currentPage == index,
                            index: index,
                            id: controller.data[index].id,
                            title: controller.data[index].title)),
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
                          ShortButtonButton(
                            title: '1.9萬',
                            subscribe: '喜歡就點讚',
                            activeIcon: Icons.favorite,
                            unActiveIcon: Icons.favorite_border,
                          ),
                          ShortButtonButton(
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
            );
          }),
          const FloatPageBackButton()
        ],
      ),
    );
  }
}
