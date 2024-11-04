import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_ads_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../localization/shared_localization_delegate.dart';

class PlayingAd extends StatefulWidget {
  final VideoPlayerInfo videoPlayerInfo;
  final Color? backgroundColor;
  final Color? buttonColor;

  const PlayingAd({
    Key? key,
    required this.videoPlayerInfo,
    this.backgroundColor,
    this.buttonColor,
  }) : super(key: key);

  @override
  State<PlayingAd> createState() => _PlayingAdState();
}

class _PlayingAdState extends State<PlayingAd> {
  final VideoAdsController controller = Get.find<VideoAdsController>();

  int adIndex = 0;
  bool adShow = false;
  Timer? _timer;
  Timer? _timer2;
  Timer? _timer3;
  bool startTimer = false;

  @override
  void initState() {
    super.initState();
  }

  void showAdTimer() {
    var bannerParamConfig = controller.videoAds.value.bannerParamConfig.config;
    List stopConfig =
        bannerParamConfig.length < 3 ? [30, 60, 180] : bannerParamConfig;
    if (startTimer) return;

    _timer = Timer(Duration(seconds: stopConfig[0]), () {
      setState(() {
        adShow = true;
      });
      autoCloseAd();
      _timer2 = Timer(Duration(seconds: stopConfig[1]), () {
        updateAdIndex();
        _timer3 = Timer.periodic(Duration(seconds: stopConfig[2]), (timer) {
          updateAdIndex();
        });
      });
    });

    setState(() {
      startTimer = true;
    });
  }

  void updateAdIndex() {
    setState(() {
      adIndex = (adIndex + 1) % controller.videoAds.value.playingAds!.length;
      adShow = true;
    });
    autoCloseAd();
  }

  void autoCloseAd() {
    if (controller.videoAds.value.playingAds?.isNotEmpty == true &&
        controller.videoAds.value.playingAds?[adIndex].isAutoClose == true) {
      Future.delayed(const Duration(seconds: 5)).then((value) => closeAd());
    }
  }

  void closeAd() {
    setState(() {
      adShow = false;
    });
  }

  @override
  void didUpdateWidget(covariant PlayingAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPlayerInfo.videoPlayerController?.value.isPlaying == true) {
      showAdTimer();
    } else {
      _timer?.cancel();
      _timer2?.cancel();
      _timer3?.cancel();

      setState(() {
        startTimer = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.dispose();
  }

  bool isColorDark(Color color) => color.computeLuminance() <= 0.5;

  @override
  Widget build(BuildContext context) {
    SharedLocalizations localizations = SharedLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;

    if (widget.videoPlayerInfo.videoPlayerController?.value.isPlaying ==
        false) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      var playingAd = controller.videoAds.value.playingAds ?? [];
      if (playingAd.isEmpty || !adShow || playingAd.length <= adIndex) {
        return const SizedBox.shrink();
      }

      final BannerPhoto currentAd = playingAd[adIndex];
      final String url = currentAd.url ?? '';
      final Color backgroundColor = widget.backgroundColor ?? Colors.blue;
      final Color buttonColor = widget.buttonColor ?? Colors.blue;
      final bool isDarkButtonColor = isColorDark(buttonColor);

      return Positioned(
        width: 85,
        right: 20,
        top: (size.width / 16 * 9 - 140) / 2,
        child: BannerLink(
          id: currentAd.id,
          url: url,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: const Alignment(0.8, 1),
                  colors: [
                    backgroundColor,
                    backgroundColor.withOpacity(0.8),
                  ],
                  tileMode: TileMode.mirror,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 5),
                        width: 20,
                        height: 16,
                        child: Image.asset(
                            'packages/shared/assets/images/recommend.png'),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close,
                          size: 14,
                          color:
                              isDarkButtonColor ? Colors.white : Colors.black,
                        ),
                        onPressed: closeAd,
                      ),
                    ],
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      child: SidImage(
                        key: ValueKey(currentAd.logoSid),
                        sid: currentAd.logoSid ?? '',
                        height: 48,
                        width: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Center(
                      child: Text(
                        currentAd.name ?? '',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color:
                              isDarkButtonColor ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Center(
                      child: Text(
                        currentAd.title ?? '',
                        style: TextStyle(
                          fontSize: 8,
                          overflow: TextOverflow.ellipsis,
                          color:
                              isDarkButtonColor ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      color: buttonColor,
                    ),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Center(
                      child: Text(
                        currentAd.button ?? localizations.translate('download'),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color:
                              isDarkButtonColor ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
