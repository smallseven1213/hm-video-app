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
        updateAdIndex('${stopConfig[1]}秒后更换广告');
        _timer3 = Timer.periodic(Duration(seconds: stopConfig[2]), (timer) {
          updateAdIndex('${stopConfig[2]}秒后更换广告，之后每180秒更换广告');
        });
      });
    });
    setState(() {
      startTimer = true;
    });
  }

  void updateAdIndex(String text) {
    logger.i(text);
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

  bool isColorDark(Color color) {
    // 計算顏色的亮度
    double luminance = color.computeLuminance();
    // 如果亮度小於或等於0.5，則認為是深色，否則是淺色
    return luminance <= 0.5;
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: const Alignment(0.8, 1),
                  colors: <Color>[
                    widget.backgroundColor ?? Colors.white,
                    widget.backgroundColor != null
                        ? widget.backgroundColor!.withOpacity(0.8)
                        : const Color.fromRGBO(255, 255, 255, 0.8),
                  ], // Gradient from https://learnui.design/tools/gradient-generator.html
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
                        child: Image.asset('assets/images/recommend.png'),
                      ),
                      IconButton(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.close,
                          size: 14,
                          color: widget.backgroundColor != null
                              ? isColorDark(widget.buttonColor!)
                                  ? Colors.white
                                  : Colors.black
                              : Colors.black,
                        ),
                        onPressed: closeAd,
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
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: widget.backgroundColor != null
                              ? isColorDark(widget.buttonColor!)
                                  ? Colors.white
                                  : Colors.black
                              : Colors.black,
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
                          color: widget.backgroundColor != null
                              ? isColorDark(widget.buttonColor!)
                                  ? Colors.white
                                  : Colors.black
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  // getChipWidgets(currentAd.tags ?? []),
                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      color: widget.buttonColor ??
                          const Color.fromRGBO(254, 44, 85, 1),
                    ),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Center(
                      child: Text(
                        currentAd.button ?? '立即下載',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: widget.buttonColor != null
                              ? isColorDark(widget.buttonColor!)
                                  ? Colors.white
                                  : Colors.black
                              : Colors.white,
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
