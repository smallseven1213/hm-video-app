import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VVodTag extends StatelessWidget {
  final Color backgroundColor;
  final Color color;
  final double fontSize;
  final String label;

  const VVodTag(
    this.label, {
    Key? key,
    this.backgroundColor = Colors.white60,
    this.color = Colors.white,
    this.fontSize = 12.0,
  }) : super(key: key);

  factory VVodTag.assign(int type) {
    switch (type) {
      case 1:
        return const VVodTag(
          'VIP',
          backgroundColor: color8_09,
        );
      case 2:
        return const VVodTag(
          '金幣',
          backgroundColor: color10_09,
          color: color10r,
        );
      case 3:
        return const VVodTag('免費', backgroundColor: color9_09);
      case 0:
      default:
        return const VVodTag('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return label.isEmpty
        ? const SizedBox.shrink()
        : Container(
            margin: const EdgeInsets.only(
              top: 6,
              left: 6,
              right: 6,
              bottom: 6,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Container(
                height: 20,
                padding: const EdgeInsets.only(
                  left: 6,
                  right: 6,
                  top: 2,
                  bottom: 2,
                ),
                decoration: BoxDecoration(color: backgroundColor),
                child: Text(
                  label.replaceAll('', '\u2060'),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize,
                  ),
                ),
              ),
            ),
          );
  }
}

class VBlockItemBig extends StatefulWidget {
  final String title;
  final Vod vod;

  const VBlockItemBig(this.vod, {Key? key, required this.title})
      : super(key: key);

  @override
  State<VBlockItemBig> createState() => _VBlockItemBigState();
}

class _VBlockItemBigState extends State<VBlockItemBig> {
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
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.vod.titleSub?.isEmpty == false
                                    ? VVodTag(
                                        widget.vod.titleSub ?? '',
                                        backgroundColor: color11_055,
                                      )
                                    : const SizedBox.shrink(),
                                widget.vod.chargeType == 2
                                    ? VVodTag(
                                        widget.vod.point.toString(),
                                        backgroundColor: color10_09,
                                        color: color10r,
                                      )
                                    : VVodTag.assign(widget.vod.subScript ?? 0),
                                // const SizedBox.shrink(),
                                // VVodTag(
                                //   '免費',
                                //   backgroundColor: color10_09,
                                //   color: color10r,
                                // ),
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
                  child: Container(
                    width: gs().width - 12,
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      widget.title.replaceAll('', '\u2060'),
                      textAlign: TextAlign.left,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(
            //   height: 0,
            // ),
          ],
        ),
      );
    });
  }
}
