import 'package:app_gs/widgets/video_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/supplier_vod_controller.dart';

const gridRatio = 128 / 227;

class SupplierVods extends StatelessWidget {
  final int id;
  final ScrollController scrollController;
  const SupplierVods(
      {Key? key, required this.id, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vodController = Get.put(SupplierVodController(
        supplierId: id, scrollController: scrollController));
    return Obx(() {
      return SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: gridRatio,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            var vod = vodController.vodList.value[index];
            return VideoPreviewWidget(
                id: id,
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
                videoViewTimes: vod.videoViewTimes!);
          },
          childCount: vodController.vodList.value.length,
        ),
      );
    });
  }
}
