import 'package:app_gs/widgets/shortcard/index.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/widgets/base_short_page_builder.dart';
import 'package:uuid/uuid.dart';
import 'general_shortcard/index.dart';
import 'shortcard_style2/index.dart';
import 'wave_loading.dart';

class BaseShortPage extends StatelessWidget {
  final Function() createController;
  final int? videoId;
  final int? itemId; // areaId, tagId, supplierId
  final bool? supportedPlayRecord;
  final bool? useCachedList;
  final bool? displayFavoriteAndCollectCount;
  final Widget? loadingWidget;
  final int? style; // 1, 2

  const BaseShortPage({
    Key? key,
    required this.createController,
    this.videoId,
    this.itemId,
    this.displayFavoriteAndCollectCount = true,
    this.supportedPlayRecord = true,
    this.useCachedList = false,
    this.loadingWidget,
    this.style = 1,
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
        shortCardBuilder: ({
          required int index,
          required bool isActive,
          required String obsKey,
          required Vod shortData,
          required Function toggleFullScreen,
        }) {
          if (style == 2) {
            return ShortCardStyle2(
              obsKey: obsKey,
              index: index,
              isActive: isActive,
              id: shortData.id,
              title: shortData.title,
              shortData: shortData,
              toggleFullScreen: toggleFullScreen,
            );
          }
          return GeneralShortCard(
            obsKey: obsKey,
            index: index,
            isActive: isActive,
            id: shortData.id,
            title: shortData.title,
            shortData: shortData,
            toggleFullScreen: toggleFullScreen,
          );
        },
        createController: createController);
  }
}
