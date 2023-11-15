import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/video_ads_controller.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/modules/video_player/video_player_consumer.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

Widget getChipWidgets(List strings) {
  // filter 掉空的字串
  final filteredStrings = strings.where((element) => element != '').toList();
  if (strings.isEmpty || filteredStrings.isEmpty) {
    return const SizedBox();
  }
  return Container(
    height: 14,
    padding: const EdgeInsets.only(bottom: 2),
    child: Wrap(
      alignment: WrapAlignment.start,
      spacing: 4,
      children: filteredStrings
          .map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 2),
              color: const Color(0xFFF2F2F2),
              child: Text(
                item,
                style: const TextStyle(
                  color: Color(0xFF979797),
                  fontSize: 7,
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}

class PlayingAd extends StatefulWidget {
  final VideoPlayerInfo videoPlayerInfo;
  const PlayingAd({
    Key? key,
    required this.videoPlayerInfo,
  }) : super(key: key);

  @override
  State<PlayingAd> createState() => _PlayingAdState();
}

class _PlayingAdState extends State<PlayingAd> {
  final VideoAdsController controller = Get.find<VideoAdsController>();
  int adIndex = 0;
  bool adShow = false;
  bool startTimer = false;
  Timer? _adTimer;

  @override
  void initState() {
    super.initState();
  }

  void startAdSequence() {
    if (startTimer || _adTimer != null) return;

    var bannerParamConfig = controller.videoAds.value.bannerParamConfig.config;
    List stopConfig =
        bannerParamConfig.length < 3 ? [30, 60, 180] : bannerParamConfig;
    int initialDelay = stopConfig[0];
    int period = stopConfig[1];

    _adTimer = Timer.periodic(Duration(seconds: period), (timer) {
      if (timer.tick == 1) {
        _showAd();
      } else {
        _updateAdIndex();
      }

      if (timer.tick * period >= stopConfig[2]) {
        timer.cancel();
        _startExtendedAdSequence(stopConfig[2]);
      }
    });

    Future.delayed(Duration(seconds: initialDelay)).then((value) {
      if (mounted) {
        setState(() => startTimer = true);
      }
    });
  }

  void _startExtendedAdSequence(int period) {
    _adTimer = Timer.periodic(Duration(seconds: period), (timer) {
      _updateAdIndex();
    });
  }

  void _showAd() {
    if (mounted) {
      setState(() {
        adShow = true;
      });
    }
    _autoCloseAd();
  }

  void _updateAdIndex() {
    if (mounted) {
      setState(() {
        adIndex = (adIndex + 1) % controller.videoAds.value.playingAds!.length;
        adShow = true;
      });
    }
    _autoCloseAd();
  }

  void _autoCloseAd() {
    if (controller.videoAds.value.playingAds?.isNotEmpty == true &&
        controller.videoAds.value.playingAds?[adIndex].isAutoClose == true) {
      Future.delayed(const Duration(seconds: 5)).then((value) => _closeAd());
    }
  }

  void _closeAd() {
    if (mounted) {
      setState(() {
        adShow = false;
      });
    }
  }

  @override
  void didUpdateWidget(covariant PlayingAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoPlayerInfo.videoPlayerController?.value.isPlaying == true) {
      startAdSequence();
    } else {
      _adTimer?.cancel();
      _adTimer = null;
      setState(() => startTimer = false);
    }
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.8, 1),
                  colors: <Color>[
                    Colors.white,
                    Color.fromRGBO(255, 255, 255, 0.8),
                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
                  tileMode: TileMode.mirror,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
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
                        child: Image.asset('assets/images/recommend.png'),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.black,
                        ),
                        onPressed: _closeAd,
                      ),
                    ],
                  ),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8.0),
                      ),
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
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Center(
                      child: Text(
                        currentAd.title ?? '',
                        style: const TextStyle(
                          fontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  // getChipWidgets(currentAd.tags ?? []),
                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: Color.fromRGBO(254, 44, 85, 1),
                    ),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Center(
                      child: Text(
                        currentAd.button ?? '立即下載',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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
