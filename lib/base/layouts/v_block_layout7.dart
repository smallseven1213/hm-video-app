import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VBlockLayout7 extends StatefulWidget {
  final Vod vod;
  final VoidCallback? onTap;
  final bool replace;
  final double horizontalSpace;
  const VBlockLayout7({
    Key? key,
    required this.vod,
    this.onTap,
    this.replace = false,
    this.horizontalSpace = 15,
  }) : super(key: key);

  @override
  _VBlockLayout7State createState() => _VBlockLayout7State();
}

class _VBlockLayout7State extends State<VBlockLayout7> {
  bool showImage = false;

  @override
  Widget build(BuildContext context) {
    var vod = widget.vod;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: widget.horizontalSpace, vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: GestureDetector(
                  onTap: () {
                    if (widget.replace) {
                      grto('/vod/${vod.id}/${widget.vod.coverHorizontal}');
                    } else {
                      gto('/vod/${vod.id}/${widget.vod.coverHorizontal}');
                    }
                    widget.onTap!();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: Stack(
                      children: [
                        VDImage(
                          url: widget.vod.getCoverHorizontalUrl(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 40,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  vod.titleSub?.isEmpty == false
                                      ? VVodTag(
                                          vod.titleSub ?? '',
                                          backgroundColor: color11_055,
                                        )
                                      : const SizedBox.shrink(),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  vod.chargeType == 2
                                      ? VVodTag(
                                          vod.point.toString(),
                                          backgroundColor: color10_09,
                                          color: color10r,
                                        )
                                      : VVodTag.assign(vod.subScript ?? 0),
                                ],
                              ),
                            ),
                            Container(
                              height: 20,
                              decoration: const BoxDecoration(
                                color: color11_055,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (widget.replace) {
                            grto(
                                '/vod/${vod.id}/${widget.vod.coverHorizontal}');
                          } else {
                            gto('/vod/${vod.id}/${widget.vod.coverHorizontal}');
                          }
                          widget.onTap!();
                        },
                        child: Text(
                          vod.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(),
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      ...(vod.publisher != null
                          ? [
                              GestureDetector(
                                onTap: () {
                                  gto('/publisher/${vod.publisher?.id}');
                                  widget.onTap!();
                                },
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: VDImage(
                                          url: vod.publisher?.getPhotoUrl(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      vod.publisher?.name ?? '',
                                      style: const TextStyle(
                                        color: color4,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          : []),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 3,
                      children: (vod.tags ?? [])
                          .getRange(0, math.min(vod.tags?.length ?? 0, 3))
                          .map(
                            (e) => VDLabelItem(
                              id: e.id,
                              label: e.name,
                              onTap: () {
                                gto('/search/${Uri.encodeFull(e.name)}');
                                widget.onTap!();
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
