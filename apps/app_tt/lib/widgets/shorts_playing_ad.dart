import 'package:app_tt/widgets/shortcard/video_title.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/banner_photo.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/banner_link.dart';
import 'package:shared/widgets/sid_image.dart';

import '../../widgets/float_page_back_button.dart';
import 'general_shortcard/next_video.dart';

class ShortsPlayingAd extends StatefulWidget {
  final BannerPhoto ad;
  final Vod? nextShortData;

  const ShortsPlayingAd(
      {super.key, required this.ad, required this.nextShortData});

  @override
  ShortPlayingAdState createState() => ShortPlayingAdState();
}

class ShortPlayingAdState extends State<ShortsPlayingAd> {
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
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
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
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                          top: 10, left: 0, right: 0, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SupplierNameWidget(data: widget.ad),
                          VideoTitleWidget(title: widget.ad.title ?? ''),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 8, right: 8),
                            child: NextVideoWidget(video: widget.nextShortData),
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

class SupplierNameWidget extends StatelessWidget {
  final BannerPhoto data;

  const SupplierNameWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return BannerLink(
      id: data.id,
      url: data.url ?? '',
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 7),
        child: Text(
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
      ),
    );
  }
}
