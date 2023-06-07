import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:shared/enums/app_routes.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/navigator/delegate.dart';

const gridRatio = 128 / 227;

class SupplierVods extends StatelessWidget {
  final int id;
  final List<Vod> vodList;
  const SupplierVods({Key? key, required this.id, required this.vodList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: gridRatio,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var vod = vodList[index];
          return VideoPreviewWidget(
              id: id,
              onOverrideRedirectTap: () {
                MyRouteDelegate.of(context).push(
                  AppRoutes.shortsBySupplier.value,
                  args: {'videoId': vod.id, 'supplierId': id},
                );
              },
              film: 2,
              hasRadius: false,
              hasTitle: false,
              imageRatio: gridRatio,
              displayCoverVertical: true,
              coverVertical: vod.coverVertical!,
              coverHorizontal: vod.coverHorizontal!,
              timeLength: vod.timeLength!,
              tags: vod.tags!,
              title: vod.title,
              videoViewTimes: vod.videoViewTimes!,
              videoCollectTimes: vod.videoCollectTimes!);
        },
        childCount: vodList.length,
      ),
    );
  }
}
