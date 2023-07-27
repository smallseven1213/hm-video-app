import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/base_short_page_builder.dart';
import 'package:uuid/uuid.dart';

import 'wave_loading.dart';

class BaseShortPage extends StatelessWidget {
  final Function() createController;
  final int? videoId;
  final int? itemId; // areaId, tagId, supplierId
  final bool? supportedPlayRecord;
  final bool? useCachedList;
  final bool? displayFavoriteAndCollectCount;
  final bool? hiddenBottomArea;
  final Widget? loadingWidget;

  const BaseShortPage({
    Key? key,
    required this.createController,
    this.videoId,
    this.itemId,
    this.displayFavoriteAndCollectCount = true,
    this.supportedPlayRecord = true,
    this.useCachedList = false,
    this.hiddenBottomArea = false,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseShortPageBuilder(
        uuid: const Uuid().v4(),
        videoId: videoId,
        itemId: itemId,
        loadingWidget: const Center(
          child: WaveLoading(
            color: Color.fromRGBO(255, 255, 255, 0.3),
            duration: Duration(milliseconds: 1000),
            size: 17,
            itemCount: 3,
          ),
        ),
        shortCardBuilder: (
                {required int index,
                required String obsKey,
                required Vod shortData,
                required Function toggleFullScreen}) =>
            Container(),
        createController: createController);
  }
}
