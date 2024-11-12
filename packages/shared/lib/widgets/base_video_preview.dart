import 'package:flutter/material.dart';
import 'package:shared/enums/shorts_type.dart';

import '../enums/app_routes.dart';
import '../models/tag.dart';
import '../models/vod.dart';
import '../navigator/delegate.dart';

abstract class BaseVideoPreviewWidget extends StatelessWidget {
  final int id;
  final String coverVertical;
  final String coverHorizontal;
  final bool displayCoverVertical;
  final int timeLength;
  final List<Tag> tags;
  final String title;
  final int? videoViewTimes;
  final int? videoFavoriteTimes;
  final double? imageRatio;
  final Vod? detail;
  final bool isEmbeddedAds;
  final bool? hasTags;
  final bool? hasInfoView;
  final int? film; // 1長視頻, 2短視頻, 3漫畫
  final int? blockId;
  final bool? hasRadius; // 要不要圓角
  final bool? hasTitle; // 要不要標題
  final bool? hasTapEvent; // 要不要點擊事件
  final bool? displayVideoFavoriteTimes;
  final bool? displayVideoTimes;
  final bool? displayViewTimes;
  final bool? displaySupplier;
  final bool? displayPublisher;
  final String? publisherName;
  final Function()? onTap;
  final Function(int id)? onOverrideRedirectTap; // 自定義路由轉址
  final bool? displayChargeType;

  const BaseVideoPreviewWidget({
    Key? key,
    required this.id,
    required this.coverVertical,
    required this.coverHorizontal,
    this.displayCoverVertical = false,
    required this.timeLength,
    required this.tags,
    required this.title,
    this.videoViewTimes = 0,
    this.videoFavoriteTimes = 0,
    this.isEmbeddedAds = false,
    this.detail,
    this.imageRatio,
    this.film = 1,
    this.hasTags = true,
    this.hasInfoView = true,
    this.blockId,
    this.hasRadius = true,
    this.hasTitle = true,
    this.onTap,
    this.hasTapEvent = true,
    this.onOverrideRedirectTap,
    this.displayVideoFavoriteTimes = true,
    this.displayVideoTimes = true,
    this.displayViewTimes = true,
    this.displaySupplier = true,
    this.displayPublisher = false,
    this.publisherName,
    this.displayChargeType = false,
  }) : super(key: key);

  void onVideoTap(BuildContext context) {
    // 定義點擊事件的邏輯
    if (onTap != null) {
      onTap!();
    }
    if (hasTapEvent == true) {
      if (onOverrideRedirectTap != null) {
        onOverrideRedirectTap!(id);
      } else {
        if (film == 1) {
          MyRouteDelegate.of(context).push(
            AppRoutes.video,
            args: {'id': id, 'blockId': blockId},
            removeSamePath: true,
          );
        } else if (film == 2) {
          MyRouteDelegate.of(context).push(
            AppRoutes.shorts,
            args: {'type': ShortsType.area, 'videoId': id, 'id': blockId},
          );
        } else if (film == 3) {
          // MyRouteDelegate.of(context).push(
          //   AppRoutes.comic.value,
          //   args: {'id': id, 'blockId': blockId},
          //   removeSamePath: true,
          // );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context);
}
