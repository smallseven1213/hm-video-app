import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/short_video_detail_controller.dart';
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
                final paddingBottom = MediaQuery.of(context).padding.bottom;

                var shortData = controller.data[index];
                var videoDetailController = Get.put(
                    ShortVideoDetailController(shortData.id),
                    tag: shortData.id.toString());
                return Column(
                  children: [
                    Expanded(
                        child: ShortCard(
                      index: index,
                      id: shortData.id,
                      title: shortData.title,
                    )),
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
                                .any((e) => e.id == shortData.id);
                            return ShortButtonButton(
                              key: ValueKey('like-${shortData.id}'),
                              count: videoDetailController
                                  .videoDetail.value!.collects,
                              subscribe: '喜歡就點讚',
                              icon: Icons.favorite_rounded,
                              isLike: isLike,
                              onTap: () {
                                if (isLike) {
                                  userFavoritesShortController
                                      .removeVideo([shortData.id]);
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
                                .any((e) => e.id == shortData.id);
                            return ShortButtonButton(
                              key: ValueKey('collection-${shortData.id}'),
                              count: videoDetailController
                                  .videoDetail.value!.collects,
                              subscribe: '添加到收藏',
                              icon: Icons.star_rounded,
                              iconSize: 30,
                              isLike: isLike,
                              onTap: () {
                                logger.i('shortData => ${shortData.id}');
                                if (isLike) {
                                  userShortCollectionController
                                      .removeVideo([shortData.id]);
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
