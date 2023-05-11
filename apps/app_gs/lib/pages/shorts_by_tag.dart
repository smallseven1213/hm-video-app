import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_short_by_tag_controller.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/short/button.dart';
import '../widgets/shortcard/index.dart';

final logger = Logger();

class ShortsByTagPage extends StatefulWidget {
  final int itemCount;
  final int id;
  final int tagId;

  const ShortsByTagPage({
    Key? key,
    required this.itemCount,
    required this.id,
    required this.tagId,
  }) : super(key: key);

  @override
  ShortsByTagPageState createState() => ShortsByTagPageState();
}

class ShortsByTagPageState extends State<ShortsByTagPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    logger.i('${widget.itemCount}, ${widget.id}, ${widget.tagId}');
    final VideoShortByTagController videoShortPopularController =
        Get.put(VideoShortByTagController(
      widget.tagId, // block.id,
      widget.id, // video.id,
    ));

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            return PageView.builder(
              controller: _pageController,
              itemCount: videoShortPopularController.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    ShortCard(
                      index: index,
                      id: videoShortPopularController.data[index].id,
                    ),
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
            );
          }),
          const FloatPageBackButton()
        ],
      ),
    );
  }
}
