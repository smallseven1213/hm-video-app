import 'package:app_gp/screens/main_screen/layout_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/channel_info.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'video_preview.dart';

class VideoBlockGridViewRow extends StatefulWidget {
  final List<Data> videoData;
  final int gridLength;
  const VideoBlockGridViewRow({
    super.key,
    required this.videoData,
    this.gridLength = 2,
  });

  @override
  _VideoBlockGridViewRowState createState() => _VideoBlockGridViewRowState();
}

class _VideoBlockGridViewRowState extends State<VideoBlockGridViewRow> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('video_block_grid_view_row_${widget.videoData.hashCode}'),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.3 && !_isVisible) {
          setState(() {
            _isVisible = true;
          });
        }
      },
      child: _isVisible
          ? Builder(
              builder: (BuildContext context) {
                print('widget.videoData.length: ${widget.videoData}');
                if (widget.videoData.length == 1) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: VideoPreviewWidget(
                          title: widget.videoData[0].title ?? '精彩好片',
                          tags: widget.videoData[0].tags ?? [],
                          timeLength: widget.videoData[0].timeLength ?? 0,
                          coverHorizontal:
                              widget.videoData[0].coverHorizontal ?? '',
                          coverVertical:
                              widget.videoData[0].coverVertical ?? '',
                          videoViewTimes:
                              widget.videoData[0].videoViewTimes ?? 0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  );
                } else if (widget.gridLength == 3 &&
                    widget.videoData.length == 2) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: VideoPreviewWidget(
                          title: widget.videoData[0].title ?? '精彩好片',
                          tags: widget.videoData[0].tags ?? [],
                          timeLength: widget.videoData[0].timeLength ?? 0,
                          coverHorizontal:
                              widget.videoData[0].coverHorizontal ?? '',
                          coverVertical:
                              widget.videoData[0].coverVertical ?? '',
                          videoViewTimes:
                              widget.videoData[0].videoViewTimes ?? 0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: VideoPreviewWidget(
                          title: widget.videoData[1].title ?? '精彩好片',
                          tags: widget.videoData[1].tags ?? [],
                          timeLength: widget.videoData[1].timeLength ?? 0,
                          coverHorizontal:
                              widget.videoData[1].coverHorizontal ?? '',
                          coverVertical:
                              widget.videoData[1].coverVertical ?? '',
                          videoViewTimes:
                              widget.videoData[1].videoViewTimes ?? 0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: SizedBox(
                          height: 200,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  );
                }

                return Row(
                  children: widget.videoData
                      .expand(
                        (e) => [
                          Expanded(
                            child: VideoPreviewWidget(
                              title: e.title ?? '精彩好片',
                              tags: e.tags ?? [],
                              timeLength: e.timeLength ?? 0,
                              coverHorizontal: e.coverHorizontal ?? '',
                              coverVertical: e.coverVertical ?? '',
                              videoViewTimes: e.videoViewTimes ?? 0,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      )
                      .toList()
                    ..removeLast(),
                );
              },
            )
          : Container(
              height: 200,
            ),
    );
  }
}
