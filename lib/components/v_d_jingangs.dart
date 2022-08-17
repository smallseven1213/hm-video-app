import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/controllers/v_jingang_controller.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class VDJingangs extends StatefulWidget {
  List<JinGang> jingangs;
  final bool? hasFrame;
  final String? title;
  final int jingangStyle;

  VDJingangs({
    Key? key,
    required this.jingangs,
    this.hasFrame = false,
    this.title = '',
    this.jingangStyle = 1,
  }) : super(key: key);

  @override
  _VDJingangsState createState() => _VDJingangsState();
}

class _VDJingangsState extends State<VDJingangs> {
  final VJingangController _controller = Get.find<VJingangController>();
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    return FutureBuilder<List<JinGang>>(
        future: Future.value(widget.jingangs),
        builder: (context, snapshot) {
          _controller.setJingangs(snapshot.data ?? []);
          var jingangs = _controller.getJingang();
          return jingangs.isEmpty
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.title?.isNotEmpty == true
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 8,
                              right: 8,
                            ),
                            child: Text(
                              widget.title ?? '',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : const SizedBox(
                            height: 6,
                          ),
                    Container(
                      height: widget.jingangStyle == 2 && jingangs.length > 4
                          ? 200
                          : widget.title?.isNotEmpty == true
                              ? 120
                              : 80,
                      padding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                            scrollbarTheme: ScrollbarThemeData(
                          thumbColor: MaterialStateProperty.all(mainBgColor),
                          trackColor: MaterialStateProperty.all(
                              const Color.fromRGBO(238, 238, 238, 1)),
                          trackBorderColor:
                              MaterialStateProperty.all(Colors.transparent),
                          trackVisibility: MaterialStateProperty.all(true),
                          mainAxisMargin: 150,
                          minThumbLength: 1,
                          radius: const Radius.circular(60),
                          thickness: MaterialStateProperty.all(4),
                          // isAlwaysShown: true,
                        )),
                        child: widget.jingangStyle == 2
                            ? Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ...jingangs.values.take(
                                          math.min(4, jingangs.values.length)),
                                      ...List.filled(
                                          (4 -
                                              math.min(
                                                  4, jingangs.values.length)),
                                          JinGang(0, "", "")),
                                    ]
                                        .map((value) => value.id == 0
                                            ? SizedBox(width: gs().width / 5)
                                            : JingangButton(
                                                value,
                                                hasFrame:
                                                    widget.hasFrame ?? false,
                                              ))
                                        .toList(),
                                  ),
                                  jingangs.values.length > 4
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            ...jingangs.values.skip(4).take(
                                                math.min(
                                                    4,
                                                    jingangs.values.length -
                                                        4)),
                                            ...List.filled(
                                                (4 -
                                                    math.min(
                                                        4,
                                                        jingangs.values.length -
                                                            4)),
                                                JinGang(0, "", "")),
                                          ]
                                              .map((value) => value.id == 0
                                                  ? SizedBox(
                                                      width: gs().width / 5)
                                                  : JingangButton(
                                                      value,
                                                      hasFrame:
                                                          widget.hasFrame ??
                                                              false,
                                                      // style: 2,
                                                    ))
                                              .toList(),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                                /*
                          * Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: (gs().width - 316) / 6,
                                runSpacing: 0,
                                children: jingangs.values
                                    .take(8)
                                    .map((value) => JingangButton(
                                          value,
                                          hasFrame: widget.hasFrame ?? false,
                                        ))
                                    .toList(),
                              )*/
                              )
                            : Scrollbar(
                                controller: _scrollController,
                                child: CustomScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  slivers: [
                                    SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                        (_c, _id) {
                                          var e =
                                              jingangs.values.elementAt(_id);
                                          return JingangButton(
                                            e,
                                            hasFrame: widget.hasFrame ?? false,
                                          );
                                        },
                                        childCount: jingangs.values.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ],
                );
        });
  }
}

class JingangButton extends StatelessWidget {
  final JinGang e;
  final bool hasFrame;
  final int style;

  const JingangButton(
    this.e, {
    Key? key,
    this.hasFrame = false,
    this.style = 1,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!e.url!.startsWith('http')) {
          gto(e.url!);
        } else {
          launch(e.url!,
              webOnlyWindowName: '_blank');
        }
      },
      child: Container(
        width: style == 2 ? (gs().width - 30) / 4 : gs().width / 5,
        margin: const EdgeInsets.only(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
        ),
        child: Card(
          elevation: hasFrame == false ? 0 : 3,
          child: Padding(
            padding: style == 2
                ? const EdgeInsets.symmetric(vertical: 9, horizontal: 10)
                : const EdgeInsets.symmetric(vertical: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                hasFrame == false
                    ? Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: color1,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(60.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60.0),
                          child: VDImage(
                            url: e.getPhotoUrl(),
                            width: 60,
                            height: 60,
                            flowContainer: false,
                          ),
                        ),
                      )
                    : VDImage(
                        url: e.getPhotoUrl(),
                        width: 50,
                        height: 40,
                        flowContainer: false,
                      ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  e.name,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
