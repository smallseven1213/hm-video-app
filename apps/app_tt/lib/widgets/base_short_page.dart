import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/short_video/short_video_provider.dart';
import 'package:shared/modules/shorts/shorts_scaffold.dart';
import 'package:shared/widgets/create_play_record.dart';
import 'package:uuid/uuid.dart';
import 'general_shortcard/index.dart';
import 'home_use_shortcard/index.dart';
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
  final String? uuid;
  final Function()? onScrollBeyondFirst;
  final String? controllerTag;

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
    this.uuid,
    this.onScrollBeyondFirst,
    this.controllerTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShortsScaffold(
        uuid: uuid ?? const Uuid().v4(),
        videoId: videoId,
        itemId: itemId,
        onScrollBeyondFirst: onScrollBeyondFirst,
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
          // var tag = const Uuid().v4();
          // print('BaseShortPage - ${shortData.id} - $tag');
          String tag =
              '${style == 2 ? 'home-use-' : 'general-'}${shortData.id.toString()}';
          return ShortVideoProvider(
            key: Key(tag),
            vodId: shortData.id,
            tag: tag,
            child: ShortVideoConsumer(
                vodId: shortData.id,
                tag: tag,
                child: ({
                  required isLoading,
                  required video,
                  required videoDetail,
                  required videoUrl,
                }) =>
                    CreatePlayRecord(
                        video: video,
                        supportedPlayRecord: supportedPlayRecord,
                        child: style == 2
                            ? HomeUseShortCard(
                                tag: tag,
                                index: index,
                                isActive: isActive,
                                id: shortData.id,
                                title: shortData.title,
                                shortData: shortData,
                                toggleFullScreen: toggleFullScreen,
                                videoUrl: videoUrl!,
                              )
                            : GeneralShortCard(
                                tag: tag,
                                index: index,
                                isActive: isActive,
                                id: shortData.id,
                                title: shortData.title,
                                shortData: shortData,
                                toggleFullScreen: toggleFullScreen,
                                videoUrl: videoUrl!,
                                controllerTag: controllerTag,
                              ))),
          );
        },
        createController: createController);
  }
}
