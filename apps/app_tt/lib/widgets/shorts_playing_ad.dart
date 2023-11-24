import 'package:app_tt/config/colors.dart';
import 'package:app_tt/widgets/actor_avatar.dart';
import 'package:app_tt/widgets/shortcard/video_title.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/color_keys.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../widgets/float_page_back_button.dart';

class ShortsPlayingAd extends StatefulWidget {
  final BannerPhoto ad;

  ShortsPlayingAd({required this.ad});

  @override
  _ShortPlayingAdState createState() => _ShortPlayingAdState();
}

class _ShortPlayingAdState extends State<ShortsPlayingAd> {
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: BannerLink(
          id: widget.ad.id,
          url: widget.ad.url ?? '',
          child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                  top: screen.padding.top + 10, bottom: screen.padding.bottom),
              child: Stack(children: [
                Center(
                  child: SidImage(
                    sid: widget.ad.photoSid,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: const [0.0, 1.51],
                          colors: [
                            Colors.black.withOpacity(0.9),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.only(
                          top: 0, left: 0, right: 0, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SupplierNameWidget(data: widget.ad),
                          VideoTitleWidget(title: widget.ad.title ?? ''),
                          const SizedBox(height: 10),
                          Container(
                            height: 4.0,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 8, right: 8),
                            child: AppDownloadAdWidget(data: widget.ad),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const FloatPageBackButton()
              ]))),
    );
  }
}

class AppDownloadAdWidget extends StatelessWidget {
  final BannerPhoto data;

  AppDownloadAdWidget({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(22, 24, 35, 1),
      ),
      child: BannerLink(
        id: data.id,
        url: data.url ?? '',
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SidImage(
                  sid: data.photoSid,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text.rich(
                  TextSpan(
                    text: '${data.name}  ',
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    children: [
                      TextSpan(
                        text: data.title ?? '',
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
  }
}

class SupplierNameWidget extends StatelessWidget {
  final BannerPhoto data;

  SupplierNameWidget({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BannerLink(
      id: data.id,
      url: data.url ?? '',
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 8),
                child: ActorAvatar(
                  photoSid: data.photoSid,
                  width: 40,
                  height: 40,
                )),
            Text(
              '@${data.name}',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                      color: Color.fromARGB(128, 0, 0, 0),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
