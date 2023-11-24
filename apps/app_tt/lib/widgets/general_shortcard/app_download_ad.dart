import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_short_ads_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../config/colors.dart';

class AppDownloadAdWidget extends StatefulWidget {
  final int videoIndex;
  const AppDownloadAdWidget({
    Key? key,
    required this.videoIndex,
  });

  @override
  _AppDownloadAdWidgetState createState() => _AppDownloadAdWidgetState();
}

class _AppDownloadAdWidgetState extends State<AppDownloadAdWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _heightAnimation;
  final ShortVideoAdsController shortVideoAdsController =
      Get.find<ShortVideoAdsController>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
    _heightAnimation =
        Tween<double>(begin: 58.0, end: 8.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Visibility(
          visible: _heightAnimation.value > 8.0,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              height: _heightAnimation.value,
              padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 7),
              child: child,
            ),
          ),
        );
      },
      child: _buildNotificationContent(),
    );
  }

  Widget _buildNotificationContent() {
    return Obx(() {
      List<BannerPhoto> appDownloadAds =
          shortVideoAdsController.videoAds.value.appDownloadAds ?? [];

      if (appDownloadAds.isEmpty) {
        return const SizedBox();
      }

      final index = widget.videoIndex % appDownloadAds.length;
      final appDownloadAd = appDownloadAds[index];

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(22, 24, 35, 1),
        ),
        child: BannerLink(
          id: appDownloadAd.id,
          url: appDownloadAd.url ?? '',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(4)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SidImage(
                    sid: appDownloadAd.photoSid,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text.rich(
                    TextSpan(
                      text: '${appDownloadAd.name}  ',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      children: [
                        TextSpan(
                          text: appDownloadAd.title ?? '',
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xffcecece)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 25,
                decoration: BoxDecoration(
                  color: AppColors.colors[ColorKeys.buttonBgSecondary],
                  borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
        ),
      );
    });
  }
}
