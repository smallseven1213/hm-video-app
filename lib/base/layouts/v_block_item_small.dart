import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VBlockItemSmall extends StatefulWidget {
  final String title;
  final Vod vod;
  const VBlockItemSmall(this.vod, {Key? key, required this.title})
      : super(key: key);

  @override
  State<VBlockItemSmall> createState() => _VBlockItemSmallState();
}

class _VBlockItemSmallState extends State<VBlockItemSmall> {
  //   with AutomaticKeepAliveClientMixin {
  // @override
  // bool get wantKeepAlive => true;

  bool showImage = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        // decoration: BoxDecoration(color: Colors.red),
        // width: constraints.maxWidth,
        // height: constraints.maxWidth * (9 / 16) * 2,
        child: Column(
          children: [
            SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxWidth * (9 / 16),
              child: GestureDetector(
                onTap: () {
                  gto('/vod/${widget.vod.id}/${widget.vod.coverHorizontal}');
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Stack(
                    children: [
                      Container(
                        child: showImage
                            ? VDImage(
                                url: widget.vod.getCoverHorizontalUrl(),
                                withDefaultPlaceholder: true,
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: color27,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                alignment: Alignment.center,
                                child: LayoutBuilder(
                                  builder: (_cc, BoxConstraints constraints) {
                                    return SizedBox(
                                      width: constraints.maxWidth / 2,
                                      height: constraints.maxHeight / 2,
                                      child: Image.asset(
                                        'assets/img/img-default@3x.png',
                                        // fit: BoxFit.contain,
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // const SizedBox.shrink(),
                                // VVodTag(
                                //   '免費',
                                //   backgroundColor: color10_09,
                                //   color: color10r,
                                // ),
                                widget.vod.chargeType == 2
                                    ? VVodTag(
                                        widget.vod.point.toString(),
                                        backgroundColor: color10_09,
                                        color: color10r,
                                      )
                                    : VVodTag.assign(widget.vod.subScript ?? 0),
                              ],
                            ),
                          ),
                          const Expanded(flex: 4, child: SizedBox.shrink()),
                          Container(
                            height: 20,
                            decoration: const BoxDecoration(
                              color: color11_055,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const VDIcon(VIcons.view),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      widget.vod.getViewTimes(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const VDIcon(VIcons.timer2),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      widget.vod.getTimeString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    gto('/vod/${widget.vod.id}/${widget.vod.coverHorizontal}');
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.title /*.replaceAll('', '\u2060')*/,
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 7,
            // ),
          ],
        ),
      );
    });
  }
}
