import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/video_short_popular_controller.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/short/button.dart';
import '../widgets/shortcard/index.dart';

final logger = Logger();

class ShortPage extends StatefulWidget {
  final int itemCount;
  final int id;
  final int areaId;

  // area id
  // video id

  const ShortPage({
    Key? key,
    required this.itemCount,
    required this.id,
    required this.areaId,
  }) : super(key: key);

  @override
  ShortPageState createState() => ShortPageState();
}


class ShortPageState extends State<ShortPage> {
  final PageController _pageController = PageController();

  // fetch vod getPopular

  @override
  Widget build(BuildContext context) {
    logger.i('${widget.itemCount}, ${widget.id}, ${widget.areaId}');
    final VideoShortPopularController videoShortPopularController = Get.put(
        VideoShortPopularController(
          widget.areaId, // block.id,
          widget.id, // video.id,
        ),
        tag: widget.id.toString());

    logger.i('ShortPageState WIDGET!!!: VIDEO ID: ${widget.id}');

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            print(
                'videoShortPopularController.videoShortPopular.value.length: ${videoShortPopularController.data.length}');
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
