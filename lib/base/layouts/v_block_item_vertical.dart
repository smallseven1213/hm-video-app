import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VBlockItemVertical extends StatefulWidget {
  final String title;
  final Vod vod;
  const VBlockItemVertical(this.vod, {Key? key, required this.title})
      : super(key: key);

  @override
  State<VBlockItemVertical> createState() => _VBlockItemVerticalState();
}

class _VBlockItemVerticalState extends State<VBlockItemVertical> {
  //   with AutomaticKeepAliveClientMixin {
  // @override
  // bool get wantKeepAlive => true;

  bool showImage = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        child: Column(
          children: [
            SizedBox(
              width: (gs().width - 32) / 3,
              height: (gs().width - 32) * 15 / 27,
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
                                url: widget.vod.getCoverVerticalUrl(),
                                fit: BoxFit.fitHeight,
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
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox.shrink(),
                                VVodTag.assign(widget.vod.subScript ?? 0),
                              ],
                            ),
                          ),
                          const Expanded(flex: 4, child: SizedBox.shrink()),
                          Container(
                            decoration: const BoxDecoration(
                              color: Colors.black38,
                            ),
                            padding: const EdgeInsets.only(
                              top: 3,
                              bottom: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const VDIcon(VIcons.eye_3),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  widget.vod.videoViewTimes.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
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
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      gto('/vod/${widget.vod.id}/${widget.vod.coverHorizontal}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Text(
                    (widget.vod.titleSub ?? ''),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: color4,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 2,
            ),
          ],
        ),
      );
    });
  }
}
