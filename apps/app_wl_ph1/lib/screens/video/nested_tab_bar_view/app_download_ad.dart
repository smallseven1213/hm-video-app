import 'package:app_wl_ph1/localization/i18n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_ads_controller.dart';
import 'package:shared/models/banner_photo.dart';
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
    controller.recordVideoViews(); // 紀錄觀看次數
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
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
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
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xff4277dc).withOpacity(0.5),
                                  const Color(0xff4277dc).withOpacity(0.7),
                                ],
                                center: const AlignmentDirectional(0.0, 0.0),
                                focal: const AlignmentDirectional(0.0, 0.0),
                                radius: 0.90,
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
                              padding: const EdgeInsets.only(top: 4, bottom: 5),
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
                              height: 25,
                              decoration: const BoxDecoration(
                                color: Color(0xff21478d),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: IntrinsicWidth(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.download,
                                        color: Color(0xffffffff),
                                        size: 16,
                                      ),
                                      Text(
                                        I18n.immediateDownload,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xffffffff),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
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
