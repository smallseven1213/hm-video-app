import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_ads_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

class PlayerPositionAd extends StatefulWidget {
  final VideoPlayerInfo? videoPlayerInfo;

  const PlayerPositionAd({
    Key? key,
    required this.videoPlayerInfo,
  }) : super(key: key);

  @override
  _PlayerPositionAdState createState() => _PlayerPositionAdState();
}

class _PlayerPositionAdState extends State<PlayerPositionAd> {
  late int seconds;
  final VideoAdsController controller = Get.find<VideoAdsController>();
  double opacity = 1.0;
  bool isVisible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    seconds = 5;
    startCountdown();
  }

  void startCountdown() {
    if (_timer != null) return; // 防止重复启动定时器

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds == 0) {
        timer.cancel();
        _closeAd();
      } else if (mounted) {
        setState(() {
          seconds--;
        });
      }
    });
  }

  void _closeAd() {
    if (mounted) {
      setState(() {
        isVisible = false;
        opacity = 0.0;
      });
      widget.videoPlayerInfo?.videoPlayerController?.play();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Obx(() {
      List<BannerPhoto> playerPositionAds =
          controller.videoAds.value.playerPositions ?? [];
      if (playerPositionAds.isEmpty) return const SizedBox.shrink();

      final index = controller.videoViews % playerPositionAds.length;
      final playerPositionAd = playerPositionAds[index];
      final Size size = MediaQuery.of(context).size;

      return AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 300),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            SizedBox(
              width: size.width * 0.95,
              child: BannerLink(
                id: playerPositionAd.id,
                url: playerPositionAd.url ?? '',
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: SidImage(
                      sid: playerPositionAd.photoSid, fit: BoxFit.cover),
                ),
              ),
            ),
            Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(top: 16, right: 16),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1),
                duration: const Duration(milliseconds: 5000),
                builder: (context, value, _) => CircularProgressIndicator(
                  color: Colors.white.withOpacity(0.7),
                  strokeWidth: 4,
                  value: value,
                ),
              ),
            ),
            GestureDetector(
              onTap: _closeAd,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(top: 17, right: 17),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Text(
                  seconds > 0 ? '${seconds}S' : '播放',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
