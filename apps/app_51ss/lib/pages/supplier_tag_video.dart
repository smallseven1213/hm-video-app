import 'package:app_51ss/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared/controllers/short_tag_vod_controller.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/enums/shorts_type.dart';
import 'package:shared/navigator/delegate.dart';

import '../widgets/list_no_more.dart';
import '../widgets/no_data.dart';
import '../widgets/sliver_video_preview_skelton_list.dart';
import '../widgets/video_preview.dart';

const gridRatio = 128 / 227;
final logger = Logger();

class SupplierTagVideoPage extends StatefulWidget {
  final int tagId;
  final String tagName;

  const SupplierTagVideoPage({
    Key? key,
    required this.tagId,
    required this.tagName,
  }) : super(key: key);

  @override
  SupplierTagVideoPageState createState() => SupplierTagVideoPageState();
}

class SupplierTagVideoPageState extends State<SupplierTagVideoPage> {
  // DISPOSED SCROLL CONTROLLER
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final vodController = ShortTagVodController(
        tagId: widget.tagId, scrollController: scrollController);

    return Scaffold(
      appBar: CustomAppBar(title: '#${widget.tagName}'),
      body: Obx(() => CustomScrollView(
            controller: vodController.scrollController,
            slivers: [
              SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var vod = vodController.vodList[index];
                    return VideoPreviewWidget(
                        id: vod.id,
                        film: 2,
                        onOverrideRedirectTap: (id) {
                          MyRouteDelegate.of(context).push(
                            AppRoutes.shorts,
                            args: {
                              'type': ShortsType.tag,
                              'videoId': vod.id,
                              'id': widget.tagId
                            },
                          );
                        },
                        hasRadius: false,
                        hasTitle: false,
                        imageRatio: gridRatio,
                        displayCoverVertical: true,
                        coverVertical: vod.coverVertical!,
                        coverHorizontal: vod.coverHorizontal!,
                        timeLength: vod.timeLength!,
                        hasTags: false,
                        tags: vod.tags!,
                        title: vod.title,
                        displayVideoTimes: false,
                        displayViewTimes: false,
                        videoViewTimes: vod.videoViewTimes!,
                        videoCollectTimes: vod.videoCollectTimes!);
                  },
                  childCount: vodController.vodList.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: gridRatio,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
              ),
              if (vodController.isListEmpty.value)
                const SliverToBoxAdapter(
                  child: NoDataWidget(),
                ),
              if (vodController.displayLoading.value)
                // ignore: prefer_const_constructors
                SliverVideoPreviewSkeletonList(),
              if (vodController.displayNoMoreData.value)
                SliverToBoxAdapter(
                  child: ListNoMore(),
                )
            ],
          )),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
