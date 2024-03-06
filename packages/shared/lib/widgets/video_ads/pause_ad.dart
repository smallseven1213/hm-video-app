import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_ads_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

// PauseAd
class PauseAd extends StatefulWidget {
  final VideoPlayerInfo videoPlayerInfo;

  const PauseAd({
    Key? key,
    required this.videoPlayerInfo,
  }) : super(key: key);

  @override
  State<PauseAd> createState() => _PauseAdState();
}

class _PauseAdState extends State<PauseAd> {
  final VideoAdsController controller = Get.find<VideoAdsController>();
  bool isManuallyPaused = false;
  bool wasPlaying = false;
  int adIndex = 0;

  @override
  void initState() {
    super.initState();
    wasPlaying =
        widget.videoPlayerInfo.videoPlayerController?.value.isPlaying ?? false;
  }

  @override
  void didUpdateWidget(covariant PauseAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    bool isCurrentlyPlaying =
        widget.videoPlayerInfo.videoPlayerController?.value.isPlaying ?? false;
    if (isCurrentlyPlaying != wasPlaying) {
      if (!isCurrentlyPlaying) {
        setState(() => isManuallyPaused = true);
      }
      wasPlaying = isCurrentlyPlaying;
    }
  }

  void _closeAd() {
    setState(() {
      isManuallyPaused = false;
      widget.videoPlayerInfo.videoPlayerController?.play();
      adIndex = (adIndex + 1) % controller.videoAds.value.stopAds!.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isManuallyPaused,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Obx(() {
          List<BannerPhoto> stopAds = controller.videoAds.value.stopAds ?? [];
          if (stopAds.isEmpty) return const SizedBox();

          final stopAd = stopAds[adIndex];
          return Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                // color: Colors.black.withOpacity(0.2),
                child: BannerLink(
                  id: stopAd.id,
                  url: stopAd.url ?? '',
                  child: SidImage(
                    sid: stopAd.photoSid,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // ... 布局代码
              Positioned(
                top: 8,
                right: 0,
                child: IconButton(
                  icon: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child:
                        const Icon(Icons.close, color: Colors.white, size: 14),
                  ),
                  onPressed: _closeAd,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
