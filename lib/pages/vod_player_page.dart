import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:universal_html/js.dart' as js;
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/base/v_icon_collection.dart';
import 'package:wgp_video_h5app/base/v_loading.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/components/video_player/v_d_video_player_fullscreen.dart'
    if (dart.library.html) 'package:wgp_video_h5app/components/video_player/v_d_video_player_fullscreen_web.dart'
    as g;
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/getx.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/models/position.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/shard.dart';
import 'package:wgp_video_h5app/styles.dart';

class FavoriteButton extends StatefulWidget {
  final Vod? vod;
  const FavoriteButton({Key? key, this.vod}) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  int count = 0;
  bool? collect;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.find<UserProvider>().addFavoriteVod(widget.vod?.id ?? 0);
        setState(() {
          if ((collect ?? widget.vod?.isCollect ?? false) == false) {
            count++;
            collect = true;
          } else {
            count--;
            collect = false;
          }
        });
      },
      child: Row(
        children: [
          VDIcon((collect ?? widget.vod?.isCollect) == true
              ? VIcons.heart_red
              : VIcons.heart_gray),
          const SizedBox(
            width: 2,
          ),
          Text(
            ((widget.vod?.videoCollectTimes ?? 0) + count).toString(),
            style: const TextStyle(color: color4),
          ),
        ],
      ),
    );
  }
}

class VodPlayerPage extends StatefulWidget {
  const VodPlayerPage({Key? key}) : super(key: key);

  @override
  State<VodPlayerPage> createState() => _VodPlayerPageState();
}

class _VodPlayerPageState extends State<VodPlayerPage>
    with SingleTickerProviderStateMixin, RouteAware {
  late Widget player;
  VVodController vodController = Get.find<VVodController>();
  int vodId = int.parse((Get.parameters['vodId'] as String));
  String vodCover = Get.parameters['coverId'] as String;
  bool _loading = true;
  double vodHeight = 235.0;
  Vod _vod = Vod(0, "loading");
  List<Vod> recommendVods = [];
  Orientation? lastOrientation;
  final GlobalKey<g.VDVideoPlayerFullScreenState> _key =
      GlobalKey<g.VDVideoPlayerFullScreenState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppController.cc.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    if (kIsWeb) {
      js.context['doPop'] = () {
        Navigator.of(context).pop();
      };
    }
  }

  @override
  void initState() {
    vodId = int.parse((Get.parameters['vodId'] as String));
    if (kIsWeb) {
      js.context['doPop'] = () {
        Navigator.of(context).pop();
      };
    }

    vodController.readyPlay(vodId).then((value) {
      Get.find<VodProvider>().getVodDetail(value!).then((value) {
        setState(() {
          _vod = value;
          _loading = false;
        });
        Get.find<InternalTagProvider>()
            .getRecommendVod(
          tagIds: (_vod.internalTagIds ?? []),
          tagId: _vod.internalTagIds?.isNotEmpty == true
              ? _vod.internalTagIds?.first
              : 0,
          vodId: _vod.id,
        )
            .then((value) {
          setState(() {
            recommendVods.addAll(value.vods);
          });
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // vodController.disposeVod();
    super.dispose();
  }

  void popOut(String target) {
    vodController.vodPlayerController?.pause();
    gto(target);
  }

  Future<void> alertModal({String title = '', Widget? content}) async {
    return showDialog(
      context: context,
      builder: (_ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          title: null,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 350,
            padding:
                const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                content ?? const SizedBox.shrink(),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: color1,
                    ),
                    child: const Text('確認'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> alertModal2(
      {String title = '', String content = '', VoidCallback? onTap}) async {
    return showDialog(
      context: context,
      builder: (_ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          title: null,
          contentPadding: EdgeInsets.zero,
          content: Container(
            height: 150,
            padding:
                const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  content,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.normal),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: color6,
                          ),
                          child: const Text(
                            '取消',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          if (onTap != null) {
                            onTap();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5.0),
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: color1,
                          ),
                          child: const Text(
                            '立刻購買',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var body = FutureBuilder<Vod?>(
      future: Future.value(),
      builder: (_context, _) {
        if (_loading || _vod.id == 0) {
          return Container(
            width: gs().width,
            height: gs().height,
            alignment: Alignment.center,
            child: const Center(
              child: VLoading(),
            ),
          );
        }
        Vod vod = vodController.ready!;
        player = g.VDVideoPlayerFullScreen(
          key: _key,
          url: vod.getVideoUrl() ?? '',
          poster:
              // '${AppController.cc.endpoint.getPhotoSidPreviewPrefix()}$vodCover',
              vodCover,
          title: vod.titleSub ?? vod.title,
          onUpdated: () async {
            await vodController.updateReadyPlay(vod);
            setState(() {});
          },
          back: () async {
            if (kIsWeb) {
              back();
              return;
            }
            if (vodHeight == 235) {
              back();
            } else {
              vodController.toggleFullscreen(force: false);
            }
          },
        );
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 0,
              collapsedHeight: vodHeight,
              expandedHeight: vodHeight,
              pinned: true,
              flexibleSpace: Stack(
                children: [
                  player,
                ],
              ),
            ),
            // 付費

            ...(((vod.chargeType ?? 5) == 2)
                ? (vod.isAvailable == true
                    ? []
                    : [
                        const SliverVerticalSpace(10),
                        SliverToBoxAdapter(
                          child: GestureDetector(
                            onTap: () async {
                              var code = await Get.find<VodProvider>()
                                  .purchase(vod.id);
                              if (code != '00' && code == '50508') {
                                alertModal2(
                                  title: '購買失敗',
                                  content: '金幣不足，請先充值',
                                  onTap: () {
                                    popOut('/member/wallet');
                                  },
                                );
                                return;
                              }
                              if (code != '00' && code != '50508') {
                                Fluttertoast.showToast(
                                  msg: code == '50508'
                                      ? '購買失敗: 金幣不足'
                                      : '購買失敗: 系統異常',
                                  gravity: ToastGravity.CENTER,
                                );
                                return;
                              }
                              await Fluttertoast.showToast(
                                msg: '購買成功',
                                gravity: ToastGravity.CENTER,
                              );
                              _key.currentState?.setState(() {
                                _key.currentState?.showBuyConfirm = false;
                                _key.currentState?.isLoading = true;
                              });
                              // print('VOD START UPDATE');
                              var _vod =
                                  await vodController.updateReadyPlay(vod);
                              // print('VOD GOT');
                              if (_vod != null) {
                                vod = _vod;
                              }
                              // print('VOD RENEW');
                              await _key.currentState?.videoPlayerController
                                  ?.dispose();
                              // print('VOD DISPOSE ${vod.getVideoUrl()}');
                              await _key.currentState?.initializePlayer(
                                vod.getVideoUrl() ?? '',
                                force: false,
                              );
                              // print('VOD INIT');
                              _key.currentState?.setState(() {
                                _key.currentState?.isTrial = false;
                                _key.currentState?.showBuyConfirm = false;
                                _key.currentState?.isLoading = false;
                              });
                              // print('VOD UPDATE STATE');
                              setState(() {});
                              _key.currentState?.play();
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: gs().width - 20,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/img/img-coin@3x.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 41,
                                    right: 36,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const VDIcon(
                                              VIcons.coin,
                                              width: 22,
                                              height: 22,
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Expanded(
                                              child: Text(
                                                '看不過癮，${vodController.ready?.buyPoint} 金幣解鎖 ',
                                                style: const TextStyle(
                                                  color: color33,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 8,
                                          left: 15,
                                          right: 15,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color33,
                                          borderRadius:
                                              BorderRadius.circular(32.0),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.white,
                                              blurRadius: 1,
                                              offset: Offset(1, 1),
                                            )
                                          ],
                                        ),
                                        child: const Text(
                                          '立即解鎖',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ])
                : (((vod.chargeType ?? 5) == 3)
                    ? (vod.isAvailable == true
                        ? []
                        : [
                            const SliverVerticalSpace(10),
                            SliverToBoxAdapter(
                              child: GestureDetector(
                                onTap: () {
                                  popOut('/member/vip');
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: gs().width - 20,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                        image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/img/img-vip@3x.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 41,
                                        right: 36,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: const [
                                                VDIcon(VIcons.diamond),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '開通VIP無限看片',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 15,
                                              right: 15,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(32.0),
                                              border: Border.all(
                                                  color: Colors.white),
                                            ),
                                            child: const Text(
                                              '立即開通',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ])
                    : [])),

            const SliverVerticalSpace(10),
            ..._vod.externalId == null
                ? []
                : [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                _vod.externalId.toString(),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: color4,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SliverVerticalSpace(5),
                  ],
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        _vod.title,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SliverVerticalSpace(10),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const VDIcon(VIcons.timer),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          _vod.getTimeString(),
                          style: const TextStyle(color: color4),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const VDIcon(VIcons.eye),
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          _vod.videoViewTimes.toString(),
                          style: const TextStyle(color: color4),
                        ),
                      ],
                    ),
                    FavoriteButton(
                      vod: _vod,
                    ),
                    InkWell(
                      onTap: () {
                        // alertModal(
                        //     title: '分享無限看',
                        //     content: Container(
                        //       child: Column(
                        //         children: const [
                        //           Text(
                        //             '成功邀請好友，可獲得VIP 1天。（無限疊加）',
                        //             style: TextStyle(
                        //               fontSize: 12,
                        //               color: color6,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ));
                      },
                      child: Row(
                        children: const [
                          VDIcon(VIcons.share_2),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            '分享',
                            style: TextStyle(color: color4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverVerticalSpace(10),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: (_vod.tags ?? [])
                      .map(
                        (e) => VDLabelItem(
                          id: e.id,
                          label: e.name,
                          onTap: () {
                            popOut('/search/${Uri.encodeFull(e.name)}');
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SliverVerticalSpace(10),
            ..._vod.publisher == null
                ? []
                : [
                    const SliverToBoxAdapter(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 5,
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                flex: 1,
                                child: Center(
                                  child: SizedBox(
                                    width: 54,
                                    height: 54,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(54.0),
                                      child: VDImage(
                                        url: _vod.publisher?.getPhotoUrl(),
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_vod.publisher?.name ?? ''),
                                    const SizedBox(height: 5),
                                    Text(
                                      '共${_vod.publisher?.containVideos ?? 1} 部視頻',
                                      style: const TextStyle(
                                        color: color6,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () {
                                  popOut('/publisher/${_vod.publisher?.id}');
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 3,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: mainBgColor,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '看更多',
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                  ],

            ...(_vod.belongVods ?? []).isEmpty
                ? []
                : [
                    const SliverToBoxAdapter(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    const SliverVerticalSpace(5),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              '連載',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '連載中 至${_vod.totalNum}集',
                              style: const TextStyle(
                                color: color4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverVerticalSpace(10),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: SizedBox(
                          width: gs().width - 20,
                          height: 168,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_ctx, _idx) {
                              var e =
                                  _vod.belongVods?[_idx] ?? Vod(0, "loading");
                              return GestureDetector(
                                onTap: () {
                                  popOut('/_vod/${e.id}/${e.coverHorizontal}');
                                },
                                child: Container(
                                  width: (gs().width - 45) / 2,
                                  margin: const EdgeInsets.only(
                                    right: 15,
                                  ),
                                  child: IntrinsicWidth(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            SizedBox(
                                              width: gs().width / 2.3,
                                              height: 93,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                                child: VDImage(
                                                  url:
                                                      e.getCoverHorizontalUrl(),
                                                ),
                                              ),
                                            ),
                                            _vod.id == e.id
                                                ? Container(
                                                    width: gs().width / 2.3,
                                                    height: 93,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4.0),
                                                      color: Colors.black54,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: const Text(
                                                      '正在播放...',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        SizedBox(
                                          width: gs().width / 2.3,
                                          child: Row(
                                            children: [
                                              _vod.id == e.id
                                                  ? const VDIcon(
                                                      VIcons.play_yellow)
                                                  : const SizedBox(height: 16),
                                              Expanded(
                                                child: Text(
                                                  '第${e.currentNum}集',
                                                  maxLines: 2,
                                                  textAlign: TextAlign.left,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Container(
                                          width: gs().width / 2.3,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            (e.titleSub ?? ''),
                                            textAlign: TextAlign.left,
                                            maxLines: 2,
                                            style: const TextStyle(
                                              color: color4,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: _vod.belongVods?.length,
                          ),
                        ),
                      ),
                    ),
                    const SliverVerticalSpace(10),
                  ],
            ...(_vod.actors ?? []).isEmpty
                ? []
                : [
                    const SliverToBoxAdapter(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    const SliverVerticalSpace(5),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          children: const [
                            Text(
                              '演員',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverVerticalSpace(10),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      sliver: SliverToBoxAdapter(
                        child: SizedBox(
                          width: gs().width - 20,
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_ctx, _id) {
                              var e = _vod.actors![_id];
                              return GestureDetector(
                                onTap: () {
                                  popOut('/actor/${e.id}');
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    right: 15,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 64,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(64.0),
                                          child: VDImage(
                                            url: e.getPhotoUrl(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      SizedBox(
                                        width: 48,
                                        child: Text(
                                          e.name,
                                          maxLines: 1,
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: _vod.actors?.length,
                          ),
                        ),
                      ),
                    ),
                    const SliverVerticalSpace(10),
                  ],

            FutureBuilder(
              future: SharedPreferencesUtil.getPositions(7),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Position>> snapshot) {
                List<Position>? positions = snapshot.data;
                if (positions?.isEmpty ?? true) {
                  return SliverToBoxAdapter(
                    child: Container(),
                  );
                }
                positions = positions!;
                Position position =
                    positions[Random().nextInt(positions.length)];

                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      width: (gs().width - 20),
                      child: LayoutBuilder(builder: (ctx, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth,
                          height: constraints.maxWidth / 2.85,
                          child: GestureDetector(
                            onTap: () {
                              if (position.url != null &&
                                  position.url!.isNotEmpty) {
                                Get.find<AdProvider>()
                                    .clickedBanner(position.id);
                                if (position.url
                                        .toString()
                                        .startsWith('http://') ||
                                    position.url
                                        .toString()
                                        .startsWith('https://')) {
                                  Get.find<VVodController>()
                                      .vodPlayerController
                                      ?.pause();
                                  launch(position.url.toString());
                                } else {
                                  popOut(position.url.toString());
                                }
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1.0),
                              child: VDImage(
                                url: '${position.getPhotoUrl()}',
                                width: constraints.maxWidth,
                                height: constraints.maxWidth / 2.85,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),

            ...recommendVods.isEmpty
                ? []
                : [
                    const SliverToBoxAdapter(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    const SliverVerticalSpace(5),
                    SliverToBoxAdapter(
                      child: Row(
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '推薦',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SliverVerticalSpace(10),
                    SliverList(
                        delegate: SliverChildBuilderDelegate(
                      (_ctx, _id) {
                        var _rVod = recommendVods[_id];
                        return VBlockLayout7(
                          replace: true,
                          horizontalSpace: 10,
                          vod: _rVod,
                          onTap: () {
                            Get.find<VVodController>()
                                .vodPlayerController
                                ?.pause();
                          },
                        );
                      },
                      childCount: recommendVods.length,
                    )),
                  ]
          ],
        );
      },
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        shadowColor: Colors.transparent,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
        ),
      ),
      body: kIsWeb
          ? body
          : OrientationBuilder(
              builder: (_c, o) {
                if (lastOrientation != o) {
                  if (o == Orientation.landscape) {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                        overlays: []).then((value) {
                      setState(() {
                        lastOrientation = o;
                        vodHeight = gs().height;
                      });
                      vodController.setFullscreen(true);
                    });
                  } else {
                    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
                        .then((value) {
                      setState(() {
                        lastOrientation = o;
                        vodHeight = 235;
                      });
                      vodController.setFullscreen(false);
                    });
                  }
                }
                return body;
              },
            ),
    );
  }
}

class SliverVerticalSpace extends StatelessWidget {
  final double? height;
  const SliverVerticalSpace(
    this.height, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
      ),
    );
  }
}
