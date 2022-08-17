import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/base/v_ads_collection.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDAdsSlider extends StatefulWidget {
  final List<VAdItem> ads;
  const VDAdsSlider(this.ads, {Key? key}) : super(key: key);

  @override
  _VDAdsSliderState createState() => _VDAdsSliderState();
}

class _VDAdsSliderState extends State<VDAdsSlider> {
  var index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void indexChanged(idx) {
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: SizedBox(
        width: gs().width - 20,
        height: 150,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 150,
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 200),
                scrollDirection: Axis.horizontal,
                onPageChanged: (idx, _) {
                  indexChanged(idx);
                },
              ),
              items: widget.ads.map(
                (e) {
                  return GestureDetector(
                    onTap: () {
                      if (e.url != null && e.url.toString().isNotEmpty) {
                        Get.find<AdProvider>().clickedBanner(e.id ?? 0);
                        if (e.url.toString().startsWith('http://') ||
                            e.url.toString().startsWith('https://')) {
                          launch(e.url.toString(),
                              webOnlyWindowName: '_blank');
                        } else {
                          gto(e.url.toString());
                        }
                      }
                    },
                    child: Container(
                      // width: double.infinity,
                      // height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: VDImage(
                          url: e.photoUrl,
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.ads
                      .asMap()
                      .map(
                        (key, value) => MapEntry(
                          key,
                          key == index
                              ? AnimatedContainer(
                                  width: 20,
                                  height: 5,
                                  margin: const EdgeInsets.only(
                                    bottom: 8,
                                    left: 2,
                                    right: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mainBgColor,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  duration: const Duration(milliseconds: 100),
                                )
                              : AnimatedContainer(
                                  width: 12,
                                  height: 5,
                                  margin: const EdgeInsets.only(
                                    bottom: 8,
                                    left: 2,
                                    right: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  duration: const Duration(milliseconds: 100),
                                ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
