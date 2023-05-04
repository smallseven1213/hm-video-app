import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_ads_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';
import 'package:shared/widgets/app_icon.dart';


class AppDownloadAd extends StatelessWidget {
  final VideoAdsController controller = Get.find<VideoAdsController>();

  @override
  Widget build(BuildContext context) {
    controller.recordVideoViews(); // 紀錄觀看次數

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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          BannerLink(
            id: appDownloadAd.id,
            url: appDownloadAd.url ?? '',
            child: AspectRatio(
              aspectRatio: 374 / 119,
              child: Container(
                padding: const EdgeInsets.only(top: 8),
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
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xff4277dc).withOpacity(0.5),
                                    const Color(0xff4277dc).withOpacity(0.7),
                                  ],
                                  center: const AlignmentDirectional(0.0, 0.0),
                                  focal: const AlignmentDirectional(0.0, 0.0),
                                  radius: 0.60,
                                  focalRadius: 0.001,
                                  stops: const [0.75, 1.0],
                                ),
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
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 8),
                                child: Center(
                                  child: Text(
                                    appDownloadAd.name ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 90,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                decoration: const BoxDecoration(
                                  color: Color(0xff21478d),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.download,
                                        color: Color(0xffffffff),
                                        size: 16,
                                      ),
                                      Text(
                                        '立即下載',
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
            ),
          )
        ],
      );
    });
  }
}
