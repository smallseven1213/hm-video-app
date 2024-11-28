import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/user_short_purchase_record_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/navigator/delegate.dart';

import '../../widgets/no_data.dart';
import '../../widgets/video_preview_with_edit.dart';

const gridRatio = 128 / 227;

class PurchaseRecordShortScreen extends StatelessWidget {
  PurchaseRecordShortScreen({Key? key}) : super(key: key);

  final userShortPurchaseRecordController =
      Get.find<UserShortPurchaseRecordController>();

  @override
  Widget build(BuildContext context) {
    userShortPurchaseRecordController.initController();
    return Obx(() {
      var videos = userShortPurchaseRecordController.data;
      if (videos.isEmpty) {
        return const NoDataWidget();
      }
      return GridView.builder(
        itemCount: videos.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: gridRatio,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        itemBuilder: (BuildContext context, int index) {
          var vod = videos[index];
          return VideoPreviewWithEditWidget(
            id: vod.id,
            film: 2,
            hasTags: false,
            isEditing: false,
            displayVideoFavoriteTimes: false,
            displayVideoTimes: false,
            displayViewTimes: false,
            onOverrideRedirectTap: (id) {
              MyRouteDelegate.of(context).push(
                AppRoutes.shortsByLocal,
                args: {'videoId': vod.id, 'itemId': 5},
              );
            },
            hasRadius: false,
            hasTitle: false,
            imageRatio: gridRatio,
            displayCoverVertical: true,
            coverVertical: vod.coverVertical ?? '',
            coverHorizontal: vod.coverHorizontal ?? '',
            timeLength: vod.timeLength ?? 0,
            tags: vod.tags ?? [],
            title: vod.title,
            videoViewTimes: vod.videoViewTimes!,
          );
        },
      );
    });
  }
}
