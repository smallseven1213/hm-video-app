import 'package:app_ab/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_ads_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/app_icon.dart';

class AppDownloadAd extends StatefulWidget {
  const AppDownloadAd({super.key});

  @override
  AppDownloadAdState createState() => AppDownloadAdState();
}

class AppDownloadAdState extends State<AppDownloadAd> {
  final VideoAdsController controller = Get.find<VideoAdsController>();

  @override
  void initState() {
    super.initState();
    controller.recordVideoViews(); // 纪录观看次数
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<BannerPhoto> appDownloadAds =
          controller.videoAds.value.appDownloadAds ?? [];
      if (appDownloadAds.isEmpty) {
        return const SizedBox();
      }

      final index = controller.videoViews % appDownloadAds.length;
      final appDownloadAd = appDownloadAds[index];

      return Column(
        children: [
          if (appDownloadAd.title != null)
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                appDownloadAd.title ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colors[ColorKeys.textPrimary],
                ),
              ),
            ),
          const SizedBox(height: 8),
          BannerLink(
            id: appDownloadAd.id,
            url: appDownloadAd.url ?? '',
            child: SizedBox(
              width: double.infinity,
              height: 120,
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                      child: SidImage(sid: appDownloadAd.photoSid),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.colors[ColorKeys.videoPreviewBg],
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppIcon(logoSid: appDownloadAd.logoSid ?? ''),
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 5),
                              child: Center(
                                child: Text(
                                  appDownloadAd.name ?? '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color:
                                        AppColors.colors[ColorKeys.textPrimary],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 90,
                              height: 25,
                              decoration: BoxDecoration(
                                color: AppColors.colors[ColorKeys.secondary],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.download,
                                      color: Color(0xffffffff),
                                      size: 16,
                                    ),
                                    Text(
                                      '立即下载',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
