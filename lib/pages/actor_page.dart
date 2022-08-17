import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/index.dart';
import 'package:wgp_video_h5app/base/layouts/index.dart';
import 'package:wgp_video_h5app/components/image/index.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/models/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class FavoriteButton extends StatefulWidget {
  final Actor? actor;
  const FavoriteButton({Key? key, this.actor}) : super(key: key);

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
        await Get.find<UserProvider>().addFavoriteActor(widget.actor?.id ?? 0);
        setState(() {
          if ((collect ?? widget.actor?.isCollect ?? false) == false) {
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
          VDIcon((collect ?? widget.actor?.isCollect) == true
              ? VIcons.heart_red
              : VIcons.heart_gray),
          const SizedBox(
            width: 2,
          ),
          Text(
            ((widget.actor?.actorCollectTimes ?? 0) + count).toString(),
            style: const TextStyle(color: color4),
          ),
        ],
      ),
    );
  }
}

class ActorPage extends StatefulWidget {
  const ActorPage({Key? key}) : super(key: key);

  @override
  _ActorPageState createState() => _ActorPageState();
}

class _ActorPageState extends State<ActorPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  late final VTabCollection _tabCollection = VActorTabs();
  int _currentIndex = 0;
  int actorId = 0;
  int page = 1;
  int limit = 100;
  bool isLastPage = false;
  bool loading = false;
  Actor? actor;
  List<Vod> actorVods = [];

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      initialIndex: _currentIndex,
      length: _tabCollection.getTabs().length,
    );
    _tabController.addListener(_handleTabChanged);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels + 50 >=
          _scrollController.position.maxScrollExtent) {
        updateNextPage();
      }
    });

    updateActor();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ActorPage oldWidget) {
    updateActor();
    super.didUpdateWidget(oldWidget);
  }

  void updateActor() {
    actorId = int.parse(Get.parameters['actorId'] as String);
    loading = true;
    Future.wait([
      actor == null
          ? Get.find<ActorProvider>().getOne(actorId)
          : Future.value(actor),
      page > ((actorVods.length) / limit).floor()
          ? Get.find<ActorProvider>().getManyLatestVodBy(
              page: page,
              limit: limit,
              actorId: actorId,
            )
          : Future.value(actorVods),
    ]).then((value) {
      setState(() {
        actor = value[0] as Actor;
        var blockVods = (value[1] as BlockVod);
        actorVods.addAll(blockVods.vods);
        isLastPage = blockVods.total == actorVods.length;
        loading = false;
      });
    });
  }

  Future<void> updateNextPage() async {
    if (isLastPage) return;
    if (loading) return;
    page += 1;
    updateActor();
  }

  void _handleTabChanged() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    actorId = int.parse(Get.parameters['actorId'] as String);
    return Scaffold(
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
        leading: InkWell(
          onTap: () {
            back();
          },
          enableFeedback: true,
          child: const Icon(
            Icons.arrow_back_ios,
            size: 14,
          ),
        ),
        title: Transform(
          transform: Matrix4.translationValues(-26, 0, 0),
          child: Center(
            child: Text(
              actor?.name ?? '演員',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
      body: actor != null
          ? CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  toolbarHeight: 0,
                  collapsedHeight: 0,
                  expandedHeight: 200,
                  // leading: null,
                  backgroundColor: Colors.white,
                  // forceElevated: innerBoxIsScrolled,
                  flexibleSpace: FlexibleSpaceBar(
                    title: null,
                    background: SizedBox(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(80.0),
                                          child: VDImage(
                                            url: actor?.getPhotoUrl(),
                                          )
                                          // : const SizedBox.shrink(),
                                          ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(actor?.name ?? ''),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: [
                                            FavoriteButton(
                                              actor: actor ?? Actor(0, '', ''),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Row(
                                              children: [
                                                const VDIcon(VIcons.view_gray),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  (actor?.containVideos ?? 0)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      color: color4),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  (actor?.description ?? '')
                                      .replaceAll('', '\u2060'),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: VDStickyTabBarDelegate(
                    backgroundColor: color7,
                    child: VDStickyTabBar(
                      tabController: _tabController,
                      currentIndex: _currentIndex,
                      controller: _tabCollection,
                      tabBarType: 2,
                    ),
                  ),
                ),
                actorVods.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            '尚無任何長視頻...',
                            style: TextStyle(
                              color: color6,
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.only(
                          left: 0,
                          right: 0,
                          top: 10,
                          bottom: 10,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_ctx, _id) {
                              var vod = actorVods[_id];
                              return VBlockLayout7(vod: vod);
                            },
                            childCount: actorVods.length,
                          ),
                        ),
                      ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}
