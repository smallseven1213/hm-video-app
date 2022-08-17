import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wgp_video_h5app/base/v_loading.dart';
import 'package:wgp_video_h5app/components/index.dart';
import 'package:wgp_video_h5app/controllers/index.dart';
import 'package:wgp_video_h5app/helpers/index.dart';
import 'package:wgp_video_h5app/providers/index.dart';
import 'package:wgp_video_h5app/styles.dart';

class ActorsPage extends StatefulWidget {
  const ActorsPage({Key? key}) : super(key: key);

  @override
  _ActorsPageState createState() => _ActorsPageState();
}

class _ActorsPageState extends State<ActorsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  final VRegionController _regionController = Get.find<VRegionController>();
  bool loading = true;

  @override
  void initState() {
    Get.find<RegionProvider>().getManyBy(page: 1).then((value) {
      setState(() {
        _regionController.setRegions(value);
        _tabController = TabController(
          vsync: this,
          initialIndex: _currentIndex,
          length: _regionController.getTabs().length,
        );
        _tabController.addListener(_handleTabChanged);
        _regionController.setCurrentRegion(_currentIndex);
        loading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChanged() {
    setState(() {
      _currentIndex = _tabController.index;
      _regionController.setCurrentRegion(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
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
          child: const Center(
            child: Text(
              '演員清單',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
      body: loading
          ? const VLoading()
          : SafeArea(
              child: CustomScrollView(
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: VDStickyTabBarDelegate(
                      backgroundColor: color7,
                      child: VDStickyTabBar(
                        tabController: _tabController,
                        currentIndex: _currentIndex,
                        controller: _regionController,
                        showExtra: false,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: _tabController,
                      // physics: const NeverScrollableScrollPhysics(),
                      children: _regionController
                          .getRegions()
                          .map(
                            (key, value) {
                              return MapEntry(
                                key,
                                Container(
                                  width: gs().width,
                                  height: gs().height,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: VDActorRegionBodyView(
                                    index: key,
                                    regionId: value.id,
                                    currentIndex: _currentIndex,
                                  ),
                                ),
                              );
                            },
                          )
                          .values
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
