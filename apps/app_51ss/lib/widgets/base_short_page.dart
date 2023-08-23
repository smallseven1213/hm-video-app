import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/shorts/shorts_scaffold.dart';
import 'package:uuid/uuid.dart';
import 'wave_loading.dart';

class BaseShortPage extends StatelessWidget {
  final Function() createController;
  final int? videoId;
  final int? itemId; // areaId, tagId, supplierId
  final bool? useCachedList;
  final bool? displayFavoriteAndCollectCount;
  final Widget? loadingWidget;
  final int? style; // 1, 2
  final String? uuid;

  const BaseShortPage({
    Key? key,
    required this.createController,
    this.videoId,
    this.itemId,
    this.displayFavoriteAndCollectCount = true,
    this.useCachedList = false,
    this.loadingWidget,
    this.style = 1,
    this.uuid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShortsScaffold(
        uuid: uuid ?? const Uuid().v4(),
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
          required Vod shortData,
          required Function toggleFullScreen,
        }) {
          return Container();
        },
        createController: createController);
  }
}
