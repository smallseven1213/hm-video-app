import 'dart:math';

import 'package:app_wl_cn1/screens/video/video_player_area/flash_loading.dart';
import 'package:flutter/material.dart';
import 'package:shared/models/vod.dart';
import 'package:shared/modules/short_video/short_video_consumer.dart';
import 'package:shared/modules/short_video/short_video_provider.dart';
import 'package:shared/modules/shorts/shorts_scaffold.dart';
import 'package:shared/widgets/create_play_record.dart';
import 'package:uuid/uuid.dart';
import 'general_shortcard/index.dart';
import 'home_use_shortcard/index.dart';

final List<String> loadingTextList = [
  '档案很大，你忍一下',
  '还没准备好，你先悠著来',
  '精彩即将呈现',
  '努力加载中',
  '让档案载一会儿',
  '美好事物，值得等待',
  '拼命搬砖中',
];

class RefreshIndicatorWidget extends StatefulWidget {
  const RefreshIndicatorWidget({Key? key}) : super(key: key);

  @override
  RefreshIndicatorWidgetState createState() => RefreshIndicatorWidgetState();
}

class RefreshIndicatorWidgetState extends State<RefreshIndicatorWidget> {
  late String loadingText;

  @override
  void initState() {
    super.initState();
    _updateLoadingText();
  }

  void _updateLoadingText() {
    setState(() {
      loadingText = loadingTextList[Random().nextInt(loadingTextList.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Center(
        child: SizedBox(
          child: Text(
            loadingText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShortsScaffold(
        uuid: uuid ?? const Uuid().v4(),
        videoId: videoId,
        itemId: itemId,
        onScrollBeyondFirst: onScrollBeyondFirst,
        loadingWidget: const Center(child: FlashLoading()),
        refreshIndicatorWidget: (refreshKey) => RefreshIndicatorWidget(
              key: Key(refreshKey),
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
                              ))),
          );
        },
        createController: createController);
  }
}
