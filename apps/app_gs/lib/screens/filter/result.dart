import 'package:app_gs/widgets/list_no_more.dart';
import 'package:app_gs/widgets/no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:shared/controllers/filter_screen_controller.dart';

import '../../widgets/video_preview.dart';

class FilterResult extends StatelessWidget {
  FilterResult({Key? key}) : super(key: key);

  final FilterScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: Obx(() => controller.filterResults.isEmpty
          ? const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 200),
                child: NoDataWidget(),
              ),
            )
          : SliverAlignedGrid.count(
              crossAxisCount: 2,
              itemCount: controller.filterResults.length,
              itemBuilder: (BuildContext context, int index) {
                var video = controller.filterResults[index];
                return VideoPreviewWidget(
                    id: video.id,
                    coverVertical: video.coverVertical!,
                    coverHorizontal: video.coverHorizontal!,
                    timeLength: video.timeLength!,
                    tags: video.tags!,
                    title: video.title,
                    videoViewTimes: video.videoViewTimes!);
              },
              mainAxisSpacing: 12.0,
              crossAxisSpacing: 10.0,
            )),
    );
  }
}
