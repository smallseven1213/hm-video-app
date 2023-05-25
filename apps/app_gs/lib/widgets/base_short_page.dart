import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_favorites_short_controlle.dart';
import 'package:shared/controllers/user_short_collection_controller.dart';
import 'package:shared/models/vod.dart';
import 'package:logger/logger.dart';
import 'package:shared/widgets/float_page_back_button.dart';

import '../screens/short/button.dart';
import 'shortcard/index.dart';

final logger = Logger();

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
    final userShortCollectionController =
        Get.find<UserShortCollectionController>();
    final userFavoritesShortController =
        Get.find<UserFavoritesShortController>();

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
                var isActive = index == currentPage;
                final paddingBottom = MediaQuery.of(context).padding.bottom;

                return Column(
                  children: [
                    Expanded(
                        child: isActive == true
                            ? ShortCard(
                                index: index,
                                isActive: isActive,
                                id: controller.data[index].id,
                                title: controller.data[index].title,
                              )
                            : const SizedBox.shrink()),
                    Container(
                      height: 76 + paddingBottom,
                      padding: EdgeInsets.only(bottom: paddingBottom),
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
                        children: [
                          Obx(() {
                            bool isLike = userFavoritesShortController.data
                                .any((e) => e.id == widget.videoId);
                            return ShortButtonButton(
                              title: '1.9萬',
                              subscribe: '喜歡就點讚',
                              activeIcon: Icons.favorite,
                              unActiveIcon: Icons.favorite_border,
                              isLike: isLike,
                              onTap: () {
                                logger.i(controller.data[index].toJson());
                                if (isLike) {
                                  userFavoritesShortController
                                      .removeVideo([widget.videoId]);
                                } else {
                                  var vod = Vod.fromJson(
                                      controller.data[index].toJson());
                                  userFavoritesShortController.addVideo(vod);
                                }
                              },
                            );
                          }),
                          Obx(() {
                            bool isLike = userShortCollectionController.data
                                .any((e) => e.id == widget.videoId);
                            return ShortButtonButton(
                              title: '1.9萬',
                              subscribe: '添加到收藏',
                              activeIcon: Icons.favorite,
                              unActiveIcon: Icons.favorite_border,
                              isLike: isLike,
                              onTap: () {
                                logger.i(controller.data[index].toJson());
                                if (isLike) {
                                  userShortCollectionController
                                      .removeVideo([widget.videoId]);
                                } else {
                                  var vod = Vod.fromJson(
                                      controller.data[index].toJson());
                                  userShortCollectionController.addVideo(vod);
                                }
                              },
                            );
                          }),
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
