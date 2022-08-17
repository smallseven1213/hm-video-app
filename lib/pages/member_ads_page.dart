import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/styles.dart';
import '../base/v_ads_collection.dart';
import '../components/v_d_ads_slider.dart';
import '../models/ads.dart';
import '../models/position.dart';
import '../providers/ads_provider.dart';
import '../shard.dart';

class MemberAdsPage extends StatefulWidget {
  final String? refer;
  const MemberAdsPage({Key? key, this.refer}) : super(key: key);

  @override
  _MemberAdsPageState createState() => _MemberAdsPageState();
}

class _MemberAdsPageState extends State<MemberAdsPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late TabController tabController;
  int tabIndex = 0;
  bool isChecked = false;
  int paymentMethod = 0;
  int status = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    tabController.addListener(() {
      changeTab(tabController.index);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void changeTab(int index) {
    tabController.animateTo(
      index,
      duration: Duration.zero,
      curve: Curves.linear,
    );
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          // title: Text(widget.title),
          backgroundColor: color1,
          shadowColor: Colors.transparent,
          toolbarHeight: 48,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: color1,
          ),
          leading: widget.refer == 'home'
              ? Container()
              : InkWell(
                  onTap: () {
                    back();
                  },
                  enableFeedback: true,
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 14,
                  ),
                ),
          title: Stack(
            children: [
              Transform(
                transform: Matrix4.translationValues(-26, 0, 0),
                child: const Center(
                  child: Text(
                    '應用中心',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: SharedPreferencesUtil.getPositions(6),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Position>> snapshot) {
                  List<VAdItem>? VAdItems = snapshot.data
                      ?.map(
                          (e) => VAdItem(e.getPhotoUrl(), url: e.url, id: e.id))
                      .toList();

                  if (VAdItems == null || VAdItems.isEmpty) {
                    return Container();
                    VAdItems = [
                      //         VAdItem(
                      //             'e0f57dde-c299-4489-9c27-dd7f61a4fcd4'),
                      // VAdItem(
                      //     'e0f57dde-c299-4489-9c27-dd7f61a4fcd4'),
                      // VAdItem(
                      //     'e0f57dde-c299-4489-9c27-dd7f61a4fcd4'),
                    ];
                  }
                  return VDAdsSlider(VAdItems);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<List<Ads>>(
                future: Get.find<AdsProvider>().getRecommendBy(),
                builder: (_ctx, _ss) {
                  if (!_ss.hasData) {
                    return const SizedBox.shrink();
                  }
                  var recommend = _ss.data ?? [];

                  if (recommend.length > 8) recommend = recommend.sublist(0, 8);

                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 0,
                      right: 0,
                    ),
                    child: Column(
                      children: [
                        Column(children: [
                          const SizedBox(
                            height: 3,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                    ),
                                    child: Text(
                                      "熱門推薦",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                              ]),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: gs().width,
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                            child: Wrap(
                              alignment: WrapAlignment.start,
                              spacing: (gs().width - 288) / 3,
                              children: [
                                ...recommend
                                    .asMap()
                                    .map((i, e) => MapEntry(
                                        i,
                                        InkWell(
                                          onTap: () => {
                                            if (e.url.startsWith('http://') ||
                                                e.url.startsWith('https://'))
                                              {
                                                launch(e.url,
                                                    webOnlyWindowName: '_blank'),
                                              }
                                            else
                                              {
                                                gto(e.url),
                                              }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 14),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 62,
                                                  width: 62,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.4),
                                                    child: VDImage(
                                                      url: e.getPhotoUrl(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 6,
                                                ),
                                                Text(e.name)
                                              ],
                                            ),
                                          ),
                                        )))
                                    .values
                                    .toList()
                              ],
                            ),
                          ),
                        ]),
                      ],
                    ),
                  );
                },
              ),
              FutureBuilder<List<Ads>>(
                future: Get.find<AdsProvider>().getManyBy(),
                builder: (_ctx, _ss) {
                  if (!_ss.hasData) {
                    return const SizedBox.shrink();
                  }
                  var records = _ss.data ?? [];

                  return Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            SizedBox(
                              width: 16,
                            ),
                            Text(
                              "大家都在玩",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ]),
                      ListView.separated(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: records.length,
                        itemBuilder: (_ctx, idx) {
                          return cardWrapper(records[idx]);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider(
                            color: Color(0xffeeeeee),
                            thickness: 1,
                            height: 1,
                          );
                        },
                      )
                    ],
                  );
                },
              ),
              const Center(
                child: Text(
                  '沒有更多了',
                  style: TextStyle(color: color5),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
        // bottomNavigationBar: widget.refer == 'home'
        //     ? VDBottomNavigationBar(
        //   collection: Get.find<VBaseMenuCollection>(),
        //   activeIndex: Get.find<AppController>().navigationBarIndex,
        //   onTap: Get.find<AppController>().toNamed,
        // )
        //     : null,
      ),
    );
  }

  Column cardWrapper(Ads ads) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [SizedBox(height: 86, child: buildText(ads))],
    );
  }

  Column buildText(Ads ads) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 20,
            ),
            Container(
              constraints: BoxConstraints(
                  minHeight: 62, minWidth: 62, maxHeight: 62, maxWidth: 62),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: VDImage(
                  url: ads.getPhotoUrl(),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 192,
                  alignment: Alignment.centerLeft,
                  height: 20,
                  child: Text(
                    ads.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'PingFangTC',
                    ),
                    maxLines: 1,
                  ),
                ),
                Text(
                  ads.description,
                  style:
                      const TextStyle(fontSize: 12, color: Color(0xFF979797)),
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            )),
            InkWell(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 12,
                  // left: 6,
                  // right: 6,
                  bottom: 12,
                ),
                height: 28,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color10,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: const Text("下載"),
              ),
              onTap: () {
                // Get.find<PositionProvider>()
                //     .addBannerClickRecord(int.parse(ads.id));

                if (ads.url.startsWith('http://') ||
                    ads.url.startsWith('https://')) {
                  launch(ads.url,
                      webOnlyWindowName: '_blank');
                } else {
                  gto(ads.url);
                }
              },
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        // const SizedBox(
        //   height: 20,
        // ),
        // const Divider(
        //   thickness: 1,
        // ),
      ],
    );
  }
}
